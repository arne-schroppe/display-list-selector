package net.wooga.uiengine.displaylistselector.parser {
	import net.wooga.uiengine.displaylistselector.IExternalPropertySource;
	import net.wooga.uiengine.displaylistselector.input.ParserInput;
	import net.wooga.uiengine.displaylistselector.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.ChildSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.TypeNameMatcher;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.DescendantSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.PropertyFilterContainsMatcher;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.PropertyFilterEqualsMatcher;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.PseudoClassMatcher;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;

	public class Parser {

		private var _allMatchers:Vector.<ParsedSelector>;
		private var _currentMatchers:ParsedSelector;

		private var _externalPropertySource:IExternalPropertySource;
		private var _pseudoClassProvider:IPseudoClassProvider;
		private var _idAttribute:String;
		private var _classAttribute:String;


		private var _matcherMap:DynamicMultiMap = new DynamicMultiMap();
		private var _isSyntaxExtensionAllowed:Boolean = true;

		private var _input:ParserInput;
		private var _specificity:Specificity;


		private var _pseudoClassArguments:Array;
		private var _isExactTypeMatcher:Boolean;

		private var _subSelector:String;



		public function Parser(externalPropertySource:IExternalPropertySource, pseudoClassProvider:IPseudoClassProvider, idAttribute:String, classAttribute:String) {
			_externalPropertySource = externalPropertySource;
			_pseudoClassProvider = pseudoClassProvider;
			_idAttribute = idAttribute;
			_classAttribute = classAttribute;
		}



		public function parse(inputString:String):ParserResult {

			_input = new ParserInput(inputString);

			_allMatchers = new <ParsedSelector>[];
			startNewMatcherSequence();


			_specificity = new Specificity();

			selectorsGroup();

			endMatcherSequence();

			return new ParserResult(_allMatchers, _specificity);
		}

		private function startNewMatcherSequence():void {

			endMatcherSequence();

			_currentMatchers = new ParsedSelector();
			_allMatchers.push(_currentMatchers);

			_pseudoClassArguments = [];
			_isExactTypeMatcher = false;
			_subSelector = "";
		}

		private function endMatcherSequence():void {
			
			if(_allMatchers.length < 1) {
				return;
			}

			_currentMatchers.selector = _subSelector;

			trace("SUBSELECTOR: " + _subSelector + "   ORIG: " + _input.originalContent);
		}


		private function selectorsGroup():void {

			simpleSelectorSequence();

			if (!_input.hasContentLeft) {
				return;
			}

			combinator();
			selectorsGroup();
		}


		private function whitespace():void {
			_input.consumeRegex(/\s*/);
		}


		private function combinator():void {

			var combinator:String = _input.consumeRegex(/(\s*>\s*)|(\s*,\s*)|(\s+)/);

			if (combinator.replace(/\s*/g, "") == ">") {
				_currentMatchers.matchers.push(getSingletonMatcher(ChildSelectorMatcher, new ChildSelectorMatcher()));
				_subSelector += ">";
			}
			else if(combinator.replace(/\s*/g, "") == ",") {
				startNewMatcherSequence();
			}
			else if (/\s+/.test(combinator)) {
				_currentMatchers.matchers.push(getSingletonMatcher(DescendantSelectorMatcher, new DescendantSelectorMatcher()));
				_subSelector += " ";
			}
		}


		private function simpleSelectorSequence():void {
			whitespace();

			_isExactTypeMatcher = true;
			if(_input.isNext("^")) {
				checkSyntaxExtensionsAllowed();
				superClassSelector();
			}
			else if (_input.isNextMatching(/\*|\w+|\(/) ) {
				typeSelector();
			}

			simpleSelectorSequence2();
		}

		private function checkSyntaxExtensionsAllowed():void {
			if (!_isSyntaxExtensionAllowed) {
				throw new ParserError("Syntax extensions must be enabled before using them");
			}
		}

		private function superClassSelector():void {
			_input.consume(1); //consuming '^'
			_subSelector += "^";
			_isExactTypeMatcher = false;
			typeSelector();
		}


		//TODO (arneschroppe 23/12/11) find out what makes up a valid identifier
		private function typeSelector():void {
			var className:String;
			if (_input.isNext("*")) {
				_input.consume(1);
				className = "*";
				//The *-selector does not limit the result set, so we wouldn't need to add it. We get exceptions though,
				//if *-selector is the last selector, so we add it anyway.
				_currentMatchers.matchers.push(getSingletonMatcher(TypeNameMatcher, className, new TypeNameMatcher(className)));
				_subSelector += "*";
				return;
			}

			if (_input.isNext("(")) {
				checkSyntaxExtensionsAllowed();

				_input.consume(1);
				className = _input.consumeRegex(/(\w|\.|\*)+/);
				_input.consumeString(")");

				_currentMatchers.matchers.push(getSingletonMatcher(TypeNameMatcher, className, _isExactTypeMatcher, new TypeNameMatcher(className, _isExactTypeMatcher)));
				_subSelector += "(" + className + ")";
			}
			else {
				className = _input.consumeRegex(/\w+/);
				_currentMatchers.matchers.push(getSingletonMatcher(TypeNameMatcher, className, _isExactTypeMatcher, new TypeNameMatcher(className, _isExactTypeMatcher)));
				_subSelector += className;
			}

			if(_isExactTypeMatcher) {
				_specificity.d++;
			}
			else {
				_specificity.e++;
			}

		}

		private function simpleSelectorSequence2():void {
			if (_input.isNext("[")) {
				attributeSelector();
				simpleSelectorSequence2();
			} else if (_input.isNext(":")) {
				pseudo();
				simpleSelectorSequence2();
			} else if (_input.isNext(".")) {
				cssClass();
				simpleSelectorSequence2();
			} else if (_input.isNext("#")) {
				cssId();
				simpleSelectorSequence2();
			}
		}


		private function cssClass():void {
			_input.consume(1);
			var className:String = _input.consumeRegex(/[a-zA-Z]+/);
			var matcher:IMatcher = new PropertyFilterContainsMatcher(_externalPropertySource, _classAttribute, className);
			_currentMatchers.matchers.push(getSingletonMatcher(PropertyFilterContainsMatcher, _externalPropertySource, _classAttribute, className, matcher));
			_subSelector += "." + className;
			_specificity.c++;
		}


		private function cssId():void {
			_input.consume(1);
			var id:String = _input.consumeRegex(/[a-zA-Z]+/);
			var matcher:IMatcher = new PropertyFilterEqualsMatcher(_externalPropertySource, _idAttribute, id);
			_currentMatchers.matchers.push(getSingletonMatcher(PropertyFilterEqualsMatcher, _externalPropertySource, _idAttribute, id, matcher));

			_subSelector += "#" + id;
			_specificity.b++;
		}





		private function pseudo():void {
			_input.consumeString(":");
			_subSelector += ":";
			var matcher:PseudoClassMatcher = functionalPseudo();

			_pseudoClassArguments = [];
			if (_input.isNext("(")) {
				pseudoClassArguments()
			}
			matcher.arguments = _pseudoClassArguments;

			var singletonAttributes:Array = [];
			singletonAttributes.push(PseudoClassMatcher);
			singletonAttributes.push(matcher.pseudoClass);
			singletonAttributes = singletonAttributes.concat(_pseudoClassArguments);
			singletonAttributes.push(matcher);

			_currentMatchers.matchers.push(getSingletonMatcher.apply(this, singletonAttributes));
			_specificity.c++;
		}


		private function functionalPseudo():PseudoClassMatcher {
			var pseudoClassName:String = _input.consumeRegex(/[a-zA-Z][\w-]*/);

			if (!_pseudoClassProvider.hasPseudoClass(pseudoClassName)) {
				throw new ParserError("Unknown pseudo-class '" + pseudoClassName + "'");
			}
			var pseudoClass:IPseudoClass = _pseudoClassProvider.getPseudoClass(pseudoClassName);
			var functionMatcher:PseudoClassMatcher = new PseudoClassMatcher(pseudoClass);
			_subSelector += pseudoClassName;
			return functionMatcher;

		}


		private function pseudoClassArguments():void {
			_input.consumeString("(");
			whitespace();
			pseudoClassArgument();
			_input.consumeString(")");

			_subSelector += "(" + _pseudoClassArguments.join(",") + ")";
		}


		private function pseudoClassArgument():void {
			var argument:String = _input.consumeRegex(/[\w\+\-][\w\+\-\s]*/);

			_pseudoClassArguments.push(argument);

			whitespace();
			if (_input.isNext(",")) {
				_input.consume(1);
				whitespace();
				pseudoClassArgument();
			}
		}


		private function attributeSelector():void {
			_input.consumeString("[");

			_subSelector += "[";

			whitespace();
			propertyExpression();
			whitespace();
			_input.consumeString("]");

			_subSelector += "]";
		}


		private function propertyExpression():void {
			whitespace();
			var property:String = propertyName();
			_subSelector += property;
			whitespace();
			var compareFunction:String = comparisonFunction();
			_subSelector += compareFunction;
			whitespace();
			var value:String = value();
			_subSelector += "'" + value + "'";
			whitespace();

			var matcher:IMatcher = matcherForCompareFunction(compareFunction, property, value);

			_currentMatchers.matchers.push(matcher);
			_specificity.c++;
		}


		private function matcherForCompareFunction(compareFunction:String, property:String, value:String):IMatcher {
			switch (compareFunction) {
				case "=":
					return getSingletonMatcher(PropertyFilterEqualsMatcher, _externalPropertySource, property, value, new PropertyFilterEqualsMatcher(_externalPropertySource, property, value));

				case "~=":
					return getSingletonMatcher(PropertyFilterContainsMatcher, _externalPropertySource, property, value, new PropertyFilterContainsMatcher(_externalPropertySource, property, value));

				default:
					return null;
			}
		}


		private function value():String {
			var quotationType:String = _input.consumeRegex(/"|'/);
			var value:String = _input.consumeRegex(new RegExp("[^\\s" + quotationType + "]+"));
			_input.consumeString(quotationType);

			return value;
		}


		private function comparisonFunction():String {
			var compareFunction:String;
			compareFunction = _input.consumeRegex(/~=|=/);
			return compareFunction;
		}


		private function propertyName():String {
			var propertyName:String = _input.consumeRegex(/[a-zA-Z]+/);
			return propertyName;
		}


		private function getSingletonMatcher(...keysAndValue):IMatcher {
			var keys:Array = keysAndValue.slice(0, keysAndValue.length - 1);

			var cachedValue:IMatcher = _matcherMap.itemForKeys(keys);
			if(cachedValue !== null) {
				return cachedValue;
			}

			var value:IMatcher = keysAndValue[keysAndValue.length - 1];
			_matcherMap.addOrReplace(keys, value);

			return value;
		}


	}
}



