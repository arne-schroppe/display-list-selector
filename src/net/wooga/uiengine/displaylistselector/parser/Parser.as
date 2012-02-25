package net.wooga.uiengine.displaylistselector.parser {
	import net.wooga.uiengine.displaylistselector.IExternalPropertySource;
	import net.wooga.uiengine.displaylistselector.input.ParserInput;
	import net.wooga.uiengine.displaylistselector.matching.matchers.ICombinator;
	import net.wooga.uiengine.displaylistselector.matching.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.ChildSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.DescendantSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.ClassMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.IdMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.PropertyFilterContainsMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.PropertyFilterEqualsMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.PseudoClassMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.TypeNameMatcher;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;

	import org.as3commons.collections.framework.IMap;
	import org.hamcrest.object.nullOr;

	public class Parser {

		private var _individualSelectors:Vector.<ParsedSelector>;
		private var _currentSelector:ParsedSelector;

		private var _externalPropertySource:IExternalPropertySource;
		private var _pseudoClassProvider:IPseudoClassProvider;


		private var _matcherMap:DynamicMultiMap = new DynamicMultiMap();
		private var _isSyntaxExtensionAllowed:Boolean = true;

		private var _input:ParserInput;
		private var _specificity:Specificity;


		private var _pseudoClassArguments:Array;
		private var _isExactTypeMatcher:Boolean;

		private var _subSelector:String;

		private var _classNameAliasMap:IMap;
		private var _originalSelector:String;


		public function Parser(externalPropertySource:IExternalPropertySource, pseudoClassProvider:IPseudoClassProvider, classNameAliasMap:IMap) {
			_externalPropertySource = externalPropertySource;
			_pseudoClassProvider = pseudoClassProvider;
			_classNameAliasMap = classNameAliasMap;
		}



		public function parse(inputString:String):Vector.<ParsedSelector> {

			_originalSelector = inputString;
			_input = new ParserInput(inputString);

			_individualSelectors = new <ParsedSelector>[];

			startNewMatcherSequence();
			selectorsGroup();
			endMatcherSequence();

			return _individualSelectors;
		}

		private function startNewMatcherSequence():void {

			endMatcherSequence();

			_currentSelector = new ParsedSelector();
			_individualSelectors.push(_currentSelector);

			_pseudoClassArguments = [];
			_isExactTypeMatcher = false;
			_subSelector = "";
			_specificity = new Specificity();
		}

		private function endMatcherSequence():void {
			
			if(_individualSelectors.length < 1) {
				return;
			}

			_currentSelector.originalSelector = _originalSelector;
			_currentSelector.selector = _subSelector;
			_currentSelector.specificity = _specificity;

			setupFilterData();
		}

		private function setupFilterData():void {
			var lastIdMatcher:IdMatcher = findMatcherInLastSimpleSelector(IdMatcher) as IdMatcher;
			if (lastIdMatcher) {
				_currentSelector.filterData.id = lastIdMatcher.id;
			}



			var lastTypeMatcher:TypeNameMatcher = findMatcherInLastSimpleSelector(TypeNameMatcher) as TypeNameMatcher;
			if (lastTypeMatcher && lastTypeMatcher.onlyMatchesImmediateClassType) {
				_currentSelector.filterData.typeName = lastTypeMatcher.typeName;
			}
		}

		private function findMatcherInLastSimpleSelector(MatcherType:Class):IMatcher {

			var matchers:Vector.<IMatcher> = _currentSelector.matchers;
			for(var i:int = matchers.length-1; i >= 0 && !(matchers[i] is ICombinator); --i) {
				var matcher:IMatcher = matchers[i];
				if(matcher is MatcherType) {
					return matcher;
				}
			}

			return null;
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
				_currentSelector.matchers.push(getSingletonMatcher(ChildSelectorMatcher, new ChildSelectorMatcher()));
				_subSelector += ">";
			}
			else if(combinator.replace(/\s*/g, "") == ",") {
				startNewMatcherSequence();
			}
			else if (/\s+/.test(combinator)) {
				_currentSelector.matchers.push(getSingletonMatcher(DescendantSelectorMatcher, new DescendantSelectorMatcher()));
				_subSelector += " ";
			}
		}


		private function simpleSelectorSequence():void {
			whitespace();


			if(_input.isNext("^")) {
				checkSyntaxExtensionsAllowed();
				superClassSelector();
			}
			else if (_input.isNextMatching(/\*|\w+|\(/) ) {
				_isExactTypeMatcher = true;
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
				_currentSelector.matchers.push(getSingletonMatcher(TypeNameMatcher, className, new TypeNameMatcher(className)));
				_subSelector += "*";
				return;
			}

			if (_input.isNext("(")) {
				checkSyntaxExtensionsAllowed();

				_input.consume(1);
				className = _input.consumeRegex(/(\w|\.|\*)+/);
				_input.consumeString(")");

				_currentSelector.matchers.push(getSingletonMatcher(TypeNameMatcher, className, _isExactTypeMatcher, new TypeNameMatcher(className, _isExactTypeMatcher)));

				_subSelector += "(" + className + ")";
			}
			else {
				className = _input.consumeRegex(/\w+/);
				var qualifiedClassName:String = _classNameAliasMap.itemFor(className);
				if(!qualifiedClassName) {
					throw new ParserError("Unknown element alias '" + className + "'");
				}
				className = qualifiedClassName;
				_currentSelector.matchers.push(getSingletonMatcher(TypeNameMatcher, className, _isExactTypeMatcher, new TypeNameMatcher(className, _isExactTypeMatcher)));
				_subSelector += className;
			}

			if(_isExactTypeMatcher) {
				_specificity.elementSelectorsAndPseudoElements++;
			}
			else {
				_specificity.isAElementSelectors++;
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
			var matcher:IMatcher = new ClassMatcher(className);
			_currentSelector.matchers.push(getSingletonMatcher(ClassMatcher, className, matcher));
			_subSelector += "." + className;
			_specificity.classAndAttributeAndPseudoSelectors++;
		}


		private function cssId():void {
			_input.consume(1);
			var id:String = _input.consumeRegex(/[a-zA-Z]+/);
			var matcher:IMatcher = new IdMatcher(id);
			_currentSelector.matchers.push(getSingletonMatcher(IdMatcher, id, matcher));

			_subSelector += "#" + id;
			_specificity.idSelector++;
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

			_currentSelector.matchers.push(getSingletonMatcher.apply(this, singletonAttributes));
			_specificity.classAndAttributeAndPseudoSelectors++;
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
			if (_input.isNext(","))
			{
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

			_currentSelector.matchers.push(matcher);
			_specificity.classAndAttributeAndPseudoSelectors++;
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



