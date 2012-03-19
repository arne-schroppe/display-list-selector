package net.wooga.selectors.parser {

	import net.wooga.selectors.IExternalPropertySource;
	import net.wooga.selectors.matching.matchers.ICombinator;
	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.matching.matchers.implementations.ChildSelectorMatcher;
	import net.wooga.selectors.matching.matchers.implementations.ClassMatcher;
	import net.wooga.selectors.matching.matchers.implementations.DescendantSelectorMatcher;
	import net.wooga.selectors.matching.matchers.implementations.IdMatcher;
	import net.wooga.selectors.matching.matchers.implementations.PropertyFilterContainsMatcher;
	import net.wooga.selectors.matching.matchers.implementations.PropertyFilterEqualsMatcher;
	import net.wooga.selectors.matching.matchers.implementations.PseudoClassMatcher;
	import net.wooga.selectors.matching.matchers.implementations.TypeNameMatcher;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;
	import net.wooga.selectors.pseudoclasses.Hover;
	import net.wooga.selectors.pseudoclasses.PseudoClass;
	import net.wooga.selectors.selector_internal;
	import net.wooga.selectors.tools.DynamicMultiMap;
	import net.wooga.selectors.tools.input.ParserInput;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMap;

	use namespace selector_internal;

	public class Parser {

		private var _individualSelectors:Vector.<SelectorImpl>;
		private var _currentSelector:SelectorImpl;

		private var _externalPropertySource:IExternalPropertySource;
		private var _pseudoClassProvider:PseudoClassProvider;

		private var _matcherMap:DynamicMultiMap = new DynamicMultiMap();
		private var _isSyntaxExtensionAllowed:Boolean = true;

		private var _input:ParserInput;
		private var _specificity:Specificity;

		private var _subSelectorStartIndex:int = 0;
		private var _subSelectorEndIndex:int = 0;

		private var _pseudoClassArguments:Array;
		private var _isExactTypeMatcher:Boolean;

		private var _originalSelector:String;


		private var _alreadyParsedSelectors:IMap = new Map();


		public function Parser(externalPropertySource:IExternalPropertySource, pseudoClassProvider:PseudoClassProvider) {
			_externalPropertySource = externalPropertySource;
			_pseudoClassProvider = pseudoClassProvider;
		}


		public function parse(inputString:String):Vector.<SelectorImpl> {

			//TODO (arneschroppe 3/19/12) this class should only parse, not cache
			if(_alreadyParsedSelectors.hasKey(inputString)) {
				return _alreadyParsedSelectors.itemFor(inputString) as Vector.<SelectorImpl>;
			}
			
			_originalSelector = inputString;
			_input = new ParserInput(inputString);

			_individualSelectors = new <SelectorImpl>[];

			startNewMatcherSequence();
			selectorsGroup();

			_subSelectorEndIndex = _input.currentIndex;
			endMatcherSequence();

			_alreadyParsedSelectors.add(inputString, _individualSelectors);

			return _individualSelectors;
		}

		private function startNewMatcherSequence():void {

			endMatcherSequence();

			_currentSelector = new SelectorImpl();
			_individualSelectors.push(_currentSelector);

			_pseudoClassArguments = [];
			_isExactTypeMatcher = false;
			_subSelectorStartIndex = _input.currentIndex;
			_specificity = new Specificity();
		}

		private function endMatcherSequence():void {
			
			if(_individualSelectors.length < 1) {
				return;
			}

			_currentSelector.originalSelectorString = _originalSelector;

			var subSelector:String = _input.getSubString(_subSelectorStartIndex, _subSelectorEndIndex);
			_currentSelector.selectorString = subSelector;
			_currentSelector.specificity = _specificity;

			setupFilterData(_currentSelector);
		}




		//TODO (arneschroppe 2/26/12) do this in a separate class?
		private function setupFilterData(selector:SelectorImpl):void {
			var lastIdMatcher:IdMatcher = findMatcherInLastSimpleSelector(selector, IdMatcher) as IdMatcher;
			if (lastIdMatcher) {
				selector.filterData.id = lastIdMatcher.id;
			}

			var lastTypeMatcher:TypeNameMatcher = findMatcherInLastSimpleSelector(selector, TypeNameMatcher) as TypeNameMatcher;
			if (lastTypeMatcher) {
				selector.filterData.typeName = lastTypeMatcher.typeName ? lastTypeMatcher.typeName.split("::").pop() : null;
				selector.filterData.isImmediateType = lastTypeMatcher.onlyMatchesImmediateType;
			}

			selector.filterData.hasHover = hasPseudoClassInLastSimpleSelector(selector, Hover);
		}


		private function hasPseudoClassInLastSimpleSelector(selector:SelectorImpl, PseudoClassType:Class):Boolean {
			var matchers:Vector.<IMatcher> = selector.matchers;
			for(var i:int = matchers.length-1; i >= 0 && !(matchers[i] is ICombinator); --i) {
				var matcher:IMatcher = matchers[i];
				if(matcher is PseudoClassMatcher && (matcher as PseudoClassMatcher).pseudoClass is PseudoClassType) {
					return true;
				}
			}

			return false;
		}

		private function findMatcherInLastSimpleSelector(selector:SelectorImpl, MatcherType:Class):IMatcher {

			var matchers:Vector.<IMatcher> = selector.matchers;
			for(var i:int = matchers.length-1; i >= 0 && !(matchers[i] is ICombinator); --i) {
				var matcher:IMatcher = matchers[i];
				if(matcher is MatcherType) {
					return matcher;
				}
			}

			return null;
		}

		//TODO ^^^ do this in separate class?



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
			}
			else if(combinator.replace(/\s*/g, "") == ",") {
				_subSelectorEndIndex = _input.currentIndex - combinator.length;
				startNewMatcherSequence();
			}
			else if (/\s+/.test(combinator)) {
				_currentSelector.matchers.push(getSingletonMatcher(DescendantSelectorMatcher, new DescendantSelectorMatcher()));
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
				return;
			}

			if (_input.isNext("(")) {
				checkSyntaxExtensionsAllowed();

				_input.consume(1);
				className = _input.consumeRegex(/(\w|\.|\*)+/);
				_input.consumeString(")");

				_currentSelector.matchers.push(getSingletonMatcher(TypeNameMatcher, className, _isExactTypeMatcher, new TypeNameMatcher(className, _isExactTypeMatcher)));
			}
			else {
				className = _input.consumeRegex(/\w+/);
				_currentSelector.matchers.push(getSingletonMatcher(TypeNameMatcher, className, _isExactTypeMatcher, new TypeNameMatcher(className, _isExactTypeMatcher)));
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
			_specificity.classAndAttributeAndPseudoSelectors++;
		}


		private function cssId():void {
			_input.consume(1);
			var id:String = _input.consumeRegex(/[a-zA-Z]+/);
			var matcher:IMatcher = new IdMatcher(id);
			_currentSelector.matchers.push(getSingletonMatcher(IdMatcher, id, matcher));

			_specificity.idSelector++;
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

			_currentSelector.matchers.push(getSingletonMatcher.apply(this, singletonAttributes));
			_specificity.classAndAttributeAndPseudoSelectors++;
		}


		private function functionalPseudo():PseudoClassMatcher {
			var pseudoClassName:String = _input.consumeRegex(/[a-zA-Z][\w-]*/);

			if (!_pseudoClassProvider.hasPseudoClass(pseudoClassName)) {
				throw new ParserError("Unknown pseudo-class '" + pseudoClassName + "'");
			}
			var pseudoClass:PseudoClass = _pseudoClassProvider.getPseudoClass(pseudoClassName);
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
			if (_input.isNext(","))
			{
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



