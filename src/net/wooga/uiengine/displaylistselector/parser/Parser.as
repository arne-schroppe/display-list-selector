package net.wooga.uiengine.displaylistselector.parser {
	import net.wooga.uiengine.displaylistselector.IExternalPropertySource;
	import net.wooga.uiengine.displaylistselector.input.ParserInput;
	import net.wooga.uiengine.displaylistselector.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.ChildSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.ClassNameMatcher;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.DescendantSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.PropertyFilterContainsMatcher;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.PropertyFilterEqualsMatcher;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.PseudoClassMatcher;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;

	public class Parser {

		private var _matchers:Vector.<IMatcher>;
		private var _input:ParserInput;
		private var _specificity:Specificity;
		private var _pseudoClassArguments:Array;
		private var _pseudoClassProvider:IPseudoClassProvider;


		private var _externalPropertySource:IExternalPropertySource;
		private var _idAttribute:String;
		private var _classAttribute:String;

		private var _matcherMap:DynamicMultiMap = new DynamicMultiMap();

		private var _isSyntaxExtensionAllowed:Boolean = true;

		public function Parser(externalPropertySource:IExternalPropertySource, pseudoClassProvider:IPseudoClassProvider, idAttribute:String, classAttribute:String) {
			_externalPropertySource = externalPropertySource;
			_pseudoClassProvider = pseudoClassProvider;
			_idAttribute = idAttribute;
			_classAttribute = classAttribute;
		}


		public function parse(inputString:String):ParserResult {

			_input = new ParserInput(inputString);
			_matchers = new <IMatcher>[];

			_specificity = new Specificity();

			selectorsGroup();

			return new ParserResult(_matchers, _specificity.asNumber());
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

			var combinator:String = _input.consumeRegex(/(\s*>\s*)|(\s+)/);

			if (combinator.replace(/\s*/g, "") == ">") {
				_matchers.push(getSingletonMatcher(ChildSelectorMatcher, new ChildSelectorMatcher()));
			}
			else if (/\s+/.test(combinator)) {
				_matchers.push(getSingletonMatcher(DescendantSelectorMatcher, new DescendantSelectorMatcher()));
			}
		}


		private function simpleSelectorSequence():void {
			whitespace();
			
			if(_isSyntaxExtensionAllowed && _input.isNext("^")) {
				superClassSelector();
			}
			else if (_input.isNextMatching(/\*|\w+/) ) {
				typeSelector();
			}

			simpleSelectorSequence2();
		}

		private function superClassSelector():void {
			_input.consume(1); //consuming ^
			//TODO (arneschroppe 16/1/12) add special type selector
			typeSelector();
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
			_matchers.push(getSingletonMatcher(PropertyFilterContainsMatcher, _externalPropertySource, _classAttribute, className, matcher));

			_specificity.b++;
		}


		private function cssId():void {
			_input.consume(1);
			var id:String = _input.consumeRegex(/[a-zA-Z]+/);
			var matcher:IMatcher = new PropertyFilterEqualsMatcher(_externalPropertySource, _idAttribute, id);
			_matchers.push(getSingletonMatcher(PropertyFilterEqualsMatcher, _externalPropertySource, _idAttribute, id, matcher));

			_specificity.a++;
		}


		//TODO (arneschroppe 23/12/11) find out what makes up a valid identifier
		private function typeSelector():void {
			var className:String;
			if (_input.isNext("*")) {
				_input.consume(1);
				className = "*";
				_matchers.push(getSingletonMatcher(ClassNameMatcher, className, new ClassNameMatcher(className)));
				//The *-selector does not limit the result set, so we wouldn't need to add it. We get exceptions though,
				//if *-selector is the last selector, so we add it anyway.
				//TODO (arneschroppe 12/1/12) come up with a better solution than this
			} else {
				className = _input.consumeRegex(/\w+/);
				_matchers.push(getSingletonMatcher(ClassNameMatcher, className, new ClassNameMatcher(className)));
				_specificity.c++;
			}


		}


		private function pseudo():void {
			_input.consumeString(":");
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

			_matchers.push(getSingletonMatcher.apply(this, singletonAttributes));
			_specificity.b++;
		}


		private function functionalPseudo():PseudoClassMatcher {
			var pseudoClassName:String = _input.consumeRegex(/[a-zA-Z][\w-]*/);

			if (!_pseudoClassProvider.hasPseudoClass(pseudoClassName)) {
				throw new ParserError("Unknown pseudo-class '" + pseudoClassName + "'");
			}
			var pseudoClass:IPseudoClass = _pseudoClassProvider.getPseudoClass(pseudoClassName);
			var functionMatcher:PseudoClassMatcher = new PseudoClassMatcher(pseudoClass);
			return functionMatcher;

		}


		private function pseudoClassArguments():void {
			_input.consumeString("(");
			whitespace();
			pseudoClassArgument();
			_input.consumeString(")");
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
			whitespace();
			propertyExpression();
			whitespace();
			_input.consumeString("]");


		}


		private function propertyExpression():void {
			whitespace();
			var property:String = propertyName();
			whitespace();
			var compareFunction:String = comparisonFunction();
			whitespace();
			var value:String = value();
			whitespace();

			var matcher:IMatcher = matcherForCompareFunction(compareFunction, property, value);

			_matchers.push(matcher);
			_specificity.b++;
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


class Specificity {
	private static const SPECIFICITY_BASE:int = 60;

	public var a:int;
	public var b:int;
	public var c:int;

	public function asNumber():Number {
		return a * Math.pow(SPECIFICITY_BASE, 2) + b * Math.pow(SPECIFICITY_BASE, 1) + c;
	}
}
