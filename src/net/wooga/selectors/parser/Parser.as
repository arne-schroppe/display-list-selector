package net.wooga.selectors.parser {

	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import mx.utils.ObjectUtil;

	import net.wooga.selectors.ExternalPropertySource;
	import net.wooga.selectors.matching.matchers.ICombinator;
	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.matching.matchers.implementations.ChildSelectorMatcher;
	import net.wooga.selectors.matching.matchers.implementations.ClassMatcher;
	import net.wooga.selectors.matching.matchers.implementations.DescendantSelectorMatcher;
	import net.wooga.selectors.matching.matchers.implementations.IdMatcher;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeBeginsWithMatcher;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeContainsMatcher;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeContainsSubstringMatcher;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeEndsWithMatcher;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeEqualsMatcher;
	import net.wooga.selectors.matching.matchers.implementations.PseudoClassMatcher;
	import net.wooga.selectors.matching.matchers.implementations.TypeNameMatcher;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeExistsMatcher;
	import net.wooga.selectors.pseudoclasses.IsA;
	import net.wooga.selectors.pseudoclasses.PseudoClass;
	import net.wooga.selectors.pseudoclasses.SettablePseudoClass;
	import net.wooga.selectors.pseudoclasses.names.BuiltinPseudoClassName;
	import net.wooga.selectors.pseudoclasses.names.PseudoClassName;
	import net.wooga.selectors.selector_internal;
	import net.wooga.selectors.tools.DynamicMultiMap;
	import net.wooga.selectors.tools.input.ParserInput;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;

	use namespace selector_internal;

	public class Parser {

		private var _individualSelectors:Vector.<SelectorImpl>;
		private var _currentSelector:SelectorImpl;

		private var _externalPropertySource:ExternalPropertySource;
		private var _pseudoClassProvider:PseudoClassProvider;

		private var _matcherMap:DynamicMultiMap = new DynamicMultiMap();
		private var _isSyntaxExtensionAllowed:Boolean = true;

		private var _input:ParserInput;
		private var _specificity:SpecificityImpl;

		private var _subSelectorStartIndex:int = 0;
		private var _subSelectorEndIndex:int = 0;

		private var _pseudoClassArguments:Array;

		private var _originalSelector:String;


		private var _alreadyParsedSelectors:Dictionary = new Dictionary();


		public function Parser(externalPropertySource:ExternalPropertySource, pseudoClassProvider:PseudoClassProvider) {
			_externalPropertySource = externalPropertySource;
			_pseudoClassProvider = pseudoClassProvider;
		}


		public function parse(inputString:String):Vector.<SelectorImpl> {

			//TODO (arneschroppe 3/19/12) this class should only parse, not cache
			if(_alreadyParsedSelectors.hasOwnProperty(inputString)) {
				return _alreadyParsedSelectors[inputString] as Vector.<SelectorImpl>;
			}
			
			_originalSelector = inputString;
			_input = new ParserInput(inputString);

			_individualSelectors = new <SelectorImpl>[];

			startNewMatcherSequence();
			selectorsGroup();

			_subSelectorEndIndex = _input.currentIndex;
			endMatcherSequence();

			_alreadyParsedSelectors[inputString] = _individualSelectors;

			return _individualSelectors;
		}

		private function startNewMatcherSequence():void {

			endMatcherSequence();

			_currentSelector = new SelectorImpl();
			_individualSelectors.push(_currentSelector);

			_pseudoClassArguments = [];
			_subSelectorStartIndex = _input.currentIndex;
			_specificity = new SpecificityImpl();
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
			var isA_PseudoClassInLastSimpleSelector:IsA = findIsAPseudoClassInLastSimpleSelector(selector);


			if(isA_PseudoClassInLastSimpleSelector) {
				selector.filterData.typeName = isA_PseudoClassInLastSimpleSelector.typeName.split("::").pop();
				selector.filterData.isImmediateType = false;
			}
			else if(lastTypeMatcher) {
				selector.filterData.typeName = lastTypeMatcher.typeName ? lastTypeMatcher.typeName.split("::").pop() : null;
				selector.filterData.isImmediateType = true;
			}



			selector.filterData.hasHover = hasHoverPseudoClassInLastSimpleSelector(selector);
		}


		//TODO (arneschroppe 3/25/12) we need a test for this, specifically to test that not just any SettablePseudoClass triggers the hasHover flag
		private function hasHoverPseudoClassInLastSimpleSelector(selector:SelectorImpl):Boolean {
			var matchers:Vector.<IMatcher> = selector.matchers;
			for(var i:int = matchers.length-1; i >= 0 && !(matchers[i] is ICombinator); --i) {
				var matcher:IMatcher = matchers[i];
				
				if(matcher is ICombinator) {
					return false;
				}
				
				if( matcher is PseudoClassMatcher &&
					(matcher as PseudoClassMatcher).pseudoClass is SettablePseudoClass &&
					((matcher as PseudoClassMatcher).pseudoClass as SettablePseudoClass).pseudoClassName == PseudoClassName.hover) {
					return true;
				}
				
				
			}

			return false;
		}



		private function findIsAPseudoClassInLastSimpleSelector(selector:SelectorImpl):IsA {
			var matchers:Vector.<IMatcher> = selector.matchers;
			for(var i:int = matchers.length-1; i >= 0 && !(matchers[i] is ICombinator); --i) {
				var matcher:IMatcher = matchers[i];

				if(matcher is ICombinator) {
					return null;
				}

				if( matcher is PseudoClassMatcher &&
					(matcher as PseudoClassMatcher).pseudoClass is IsA) {
					return (matcher as PseudoClassMatcher).pseudoClass as IsA;
				}
			}

			return null;
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
				_currentSelector.matchers.push(new ChildSelectorMatcher());
			}
			else if(combinator.replace(/\s*/g, "") == ",") {
				_subSelectorEndIndex = _input.currentIndex - combinator.length;
				startNewMatcherSequence();
			}
			else if (/\s+/.test(combinator)) {
				_currentSelector.matchers.push(new DescendantSelectorMatcher());
			}
		}


		private function simpleSelectorSequence():void {
			whitespace();

			if (_input.isNextMatching(/\*|\w+|\(/) ) {
				typeSelector();
			}

			simpleSelectorSequence2();
		}

		private function checkSyntaxExtensionsAllowed():void {
			if (!_isSyntaxExtensionAllowed) {
				throw new ParserError("Syntax extensions must be enabled before using them");
			}
		}



		//TODO (arneschroppe 23/12/11) find out what makes up a valid identifier
		private function typeSelector():void {
			var className:String;
			if (_input.isNext("*")) {
				_input.consume(1);
				className = "*";
				//The *-selector does not limit the result set, so we wouldn't need to add it. We get exceptions though,
				//if *-selector is the last selector, so we add it anyway.
				_currentSelector.matchers.push(new TypeNameMatcher(className));
				return;
			}

			//TODO (arneschroppe 3/25/12) figure out specificity rules. We can't give isA selector a specificity based on super classes, since we don't know the specific class. But maybe we can, if it's a FQCN
			if (_input.isNext("(")) {
				checkSyntaxExtensionsAllowed();

				_input.consume(1);
				className = _input.consumeRegex(/(\w|\.|\*)+/);
				_input.consumeString(")");

				_currentSelector.matchers.push(new TypeNameMatcher(className));
			}
			else {
				className = _input.consumeRegex(/\w+/);
				_currentSelector.matchers.push(new TypeNameMatcher(className));
			}

			_specificity.elementSelectorsAndPseudoElements++;

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
			var className:String = _input.consumeRegex(/[a-zA-Z\-_]+/);
			var matcher:IMatcher = new ClassMatcher(className);
			_currentSelector.matchers.push(matcher);
			_specificity.classAndAttributeAndPseudoSelectors++;
		}


		private function cssId():void {
			_input.consume(1);
			var id:String = _input.consumeRegex(/[a-zA-Z\-_]+/);
			var matcher:IMatcher = new IdMatcher(id);
			_currentSelector.matchers.push(matcher);

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

			_currentSelector.matchers.push(matcher);

			//Special treatment for is-a pseudo classes: their specificity is always lower than that of element selectors
			if(matcher.pseudoClass is IsA) {
				_specificity.isAPseudoClassSelectors++;
			}
			else {
				_specificity.classAndAttributeAndPseudoSelectors++;
			}

		}


		private function functionalPseudo():PseudoClassMatcher {
			var pseudoClassName:String = _input.consumeRegex(/[a-zA-Z][\w\-]*/);

			if (pseudoClassName != BuiltinPseudoClassName.is_a && !_pseudoClassProvider.hasPseudoClass(pseudoClassName)) {
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
			var argument:String = _input.consumeRegex(/[\w\+\-\.][\w\+\-\.\s]*/);

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
			attributeExpression();
			whitespace();
			_input.consumeString("]");

		}


		private function attributeExpression():void {
			whitespace();
			var property:String = propertyName();
			whitespace();

			var matcher:IMatcher;
			if(_input.isNext("]")) {
				matcher = new AttributeExistsMatcher(property);
			}
			else {
				var compareFunction:String = comparisonFunction();
				whitespace();
				var value:String = attributeValue();
				whitespace();

				matcher = matcherForCompareFunction(compareFunction, property, value);
			}

			_currentSelector.matchers.push(matcher);
			_specificity.classAndAttributeAndPseudoSelectors++;
		}


		private function matcherForCompareFunction(compareFunction:String, property:String, value:String):IMatcher {
			switch (compareFunction) {
				case "=":
					return new AttributeEqualsMatcher(_externalPropertySource, property, value);

				case "~=":
					return new AttributeContainsMatcher(_externalPropertySource, property, value);

				case "^=":
					return new AttributeBeginsWithMatcher(_externalPropertySource, property, value);

				case "$=":
					return new AttributeEndsWithMatcher(_externalPropertySource, property, value);

				case "*=":
					return new AttributeContainsSubstringMatcher(_externalPropertySource, property, value);

				default:
					return null;
			}
		}


		private function attributeValue():String {
			var quotationType:String = _input.consumeRegex(/"|'/);
			var value:String = _input.consumeRegex(new RegExp("[^\\s" + quotationType + "]+"));
			_input.consumeString(quotationType);

			return value;
		}


		private function comparisonFunction():String {
			var compareFunction:String;
			compareFunction = _input.consumeRegex(/~=|\*=|\$=|\^=|=/);
			return compareFunction;
		}


		private function propertyName():String {
			var propertyName:String = _input.consumeRegex(/[a-zA-Z]+/);
			return propertyName;
		}
	}
}



