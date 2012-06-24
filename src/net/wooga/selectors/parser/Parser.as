package net.wooga.selectors.parser {

	import flash.utils.Dictionary;

	import net.wooga.selectors.ExternalPropertySource;
	import net.wooga.selectors.matching.combinators.Combinator;
	import net.wooga.selectors.matching.combinators.CombinatorType;
	import net.wooga.selectors.matching.combinators.MatcherFamily;
	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.matching.matchers.implementations.ClassMatcher;
	import net.wooga.selectors.matching.matchers.implementations.IdMatcher;
	import net.wooga.selectors.matching.matchers.implementations.PseudoClassMatcher;
	import net.wooga.selectors.matching.matchers.implementations.TypeNameMatcher;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeBeginsWithMatcher;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeContainsMatcher;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeContainsSubstringMatcher;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeEndsWithMatcher;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeEqualsMatcher;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeExistsMatcher;
	import net.wooga.selectors.matching.matchersequence.MatcherSequenceImpl;
	import net.wooga.selectors.namespaces.selector_internal;
	import net.wooga.selectors.pseudoclasses.IsA;
	import net.wooga.selectors.pseudoclasses.PseudoClass;
	import net.wooga.selectors.pseudoclasses.names.StaticPseudoClassName;
	import net.wooga.selectors.tools.input.ParserInput;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;

	use namespace selector_internal;

	public class Parser {


		//TODO (arneschroppe 07/06/2012) keep a map of normalized simpleselectorsequences to thei matchersequences. Don't reparse known sequences. Maybe add a clone method, so we can reuse sequences with different parent combinators (i.e. clone the whole sequence but exchange the combinator). A shallow copy (i.e. no cloning of simpleselectors/matchers) would be sufficient here


		private var _individualSelectors:Vector.<SelectorImpl>;


		private var _externalPropertySource:ExternalPropertySource;
		private var _pseudoClassProvider:PseudoClassProvider;


		private var _input:ParserInput;
		private var _specificity:SpecificityImpl;

		private var _currentSelector:SelectorImpl;
		private var _currentMatcherSequence:MatcherSequenceImpl;


		private var _subSelectorStartIndex:int = 0;
		private var _subSelectorEndIndex:int = 0;
		private var _currentSelectorHasPseudoElement:Boolean = false;
		private var _pseudoElementName:String;

		private var _pseudoClassArguments:Array;
		private var _originalSelector:String;

		private var _normalizedSimpleSelectorSequence:String;

		private var _alreadyParsedSelectors:Dictionary = new Dictionary();


		public function Parser(externalPropertySource:ExternalPropertySource, pseudoClassProvider:PseudoClassProvider) {
			_externalPropertySource = externalPropertySource;
			_pseudoClassProvider = pseudoClassProvider;
		}


		public function parse(inputString:String):Vector.<SelectorImpl> {
			if(_alreadyParsedSelectors.hasOwnProperty(inputString)) {
				return _alreadyParsedSelectors[inputString] as Vector.<SelectorImpl>;
			}

			parseIndividualSelectors(inputString);

			_alreadyParsedSelectors[inputString] = _individualSelectors;
			return _individualSelectors;
		}


		private function parseIndividualSelectors(inputString:String):void {
			setupParsing(inputString);

			startNewMatcherSequence();
			selectorsGroup();

			_subSelectorEndIndex = _input.currentIndex;
			endMatcherSequence();
		}


		private function setupParsing(inputString:String):void {
			_originalSelector = inputString;
			_input = new ParserInput(inputString);
			_individualSelectors = new <SelectorImpl>[];
			_normalizedSimpleSelectorSequence = "";
		}


		private function startNewMatcherSequence():void {

			endMatcherSequence();

			_currentMatcherSequence = new MatcherSequenceImpl(); //TODO (arneschroppe 24/06/2012) seems to be duplicate code
			_normalizedSimpleSelectorSequence = "";

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

			_currentSelector.selectorGroupString = _originalSelector;

			var subSelector:String = _input.getSubString(_subSelectorStartIndex, _subSelectorEndIndex);
			_currentSelector.selectorString = subSelector;
			_currentSelector.specificity = _specificity;

			if(_pseudoElementName) {
				_currentSelector.pseudoElementName = _pseudoElementName;
			}

			_currentSelectorHasPseudoElement = false;
		}



		private function selectorsGroup():void {

			simpleSelectorSequence();

			//TODO (arneschroppe 24/06/2012) maybe we should hash the normalized sequence?
			_currentMatcherSequence.normalizedSelectorSequenceString = _normalizedSimpleSelectorSequence;
			_currentSelector.matcherSequences.push(_currentMatcherSequence);

			//is  the rest of the sequence whitespace?
			if (_input.isNextMatching(/\s+$/)) {
				whitespace();
				return;
			}

			if (!_input.hasContentLeft) {
				return;
			}

			_currentMatcherSequence = new MatcherSequenceImpl(); //TODO (arneschroppe 24/06/2012) seems to be duplicate code
			_normalizedSimpleSelectorSequence = "";
			combinator();
			selectorsGroup();
		}


		private function whitespace():void {
			_input.consumeRegex(/\s*/);
		}


		//TODO (arneschroppe 09/04/2012) comma should be handled in selectors group!
		private function combinator():void {


			var combinator:String = _input.consumeRegex(/(\s*>\s*)|(\s*,\s*)|(\s*\+\s*)|(\s*~\s*)|(\s+)/);
			var combinatorOnly:String = combinator.replace(/\s*/g, "");

			if (combinatorOnly == ">") {
				checkPseudoElement();
				_currentMatcherSequence.parentCombinator = new Combinator(MatcherFamily.ANCESTOR_COMBINATOR, CombinatorType.CHILD);
			}
			else if(combinatorOnly == ",") {
				_subSelectorEndIndex = _input.currentIndex - combinator.length;
				startNewMatcherSequence();
			}
			else if(combinatorOnly == "+") {
				checkPseudoElement();
				_currentMatcherSequence.parentCombinator = new Combinator(MatcherFamily.SIBLING_COMBINATOR, CombinatorType.ADJACENT_SIBLING);
			}
			else if(combinatorOnly == "~") {
				checkPseudoElement();
				_currentMatcherSequence.parentCombinator = new Combinator(MatcherFamily.SIBLING_COMBINATOR, CombinatorType.GENERAL_SIBLING);
			}
			else if (/\s+/.test(combinator)) {
				checkPseudoElement();
				_currentMatcherSequence.parentCombinator = new Combinator(MatcherFamily.ANCESTOR_COMBINATOR, CombinatorType.DESCENDANT);
			}
			
			 
		}

		private function checkPseudoElement():void {
			if(_currentSelectorHasPseudoElement) {
				throw new ParserError("Pseudo-element '" + _pseudoElementName + "' must be last element in simple selector sequence. (In selector: '" + _originalSelector + "')" )
			}
		}


		private function simpleSelectorSequence():void {
			whitespace();

			if (_input.isNextMatching(/\*|\w+|\(/) ) {
				typeSelector();
			}

			classAndIdAndPseudoAndAttribute();
		}



		//TODO (arneschroppe 23/12/11) find out what makes up a valid identifier
		private function typeSelector():void {
			var className:String;
			if (_input.isNext("*")) {
				_input.consume(1);
				className = "*";
				//The *-selector does not limit the result set, so we wouldn't need to add it. We get exceptions though,
				//if *-selector is the last selector, so we add it anyway.
				_currentMatcherSequence.elementMatchers.push(new TypeNameMatcher(className));
				_normalizedSimpleSelectorSequence += "*";
				return;
			}


			if (_input.isNext("(")) {
				_input.consume(1);
				className = _input.consumeRegex(/(\w|\.|\*)+/);
				_input.consumeString(")");

				_currentMatcherSequence.elementMatchers.push(new TypeNameMatcher(className));
				_normalizedSimpleSelectorSequence += "(" + className + ")";
			}
			else {
				className = _input.consumeRegex(/\w+/);
				_currentMatcherSequence.elementMatchers.push(new TypeNameMatcher(className));
				_normalizedSimpleSelectorSequence += className;
			}

			_specificity.elementSelectorsAndPseudoElements++;

		}

		private function classAndIdAndPseudoAndAttribute():void {
			if (_input.isNext("[")) {
				attributeSelector();
				classAndIdAndPseudoAndAttribute();
			} else if (_input.isNext("::")) {
				pseudoElement();
				//there can't be any other objects after this one
			} else if (_input.isNext(":")) {
				pseudoClass();
				classAndIdAndPseudoAndAttribute();
			} else if (_input.isNext(".")) {
				cssClass();
				classAndIdAndPseudoAndAttribute();
			} else if (_input.isNext("#")) {
				cssId();
				classAndIdAndPseudoAndAttribute();
			}
		}


		private function cssClass():void {
			_input.consume(1);
			var className:String = _input.consumeRegex(/[a-zA-Z\-_]+/);

			_normalizedSimpleSelectorSequence += "." + className;

			var matcher:Matcher = new ClassMatcher(className);
			_currentMatcherSequence.elementMatchers.push(matcher);
			_specificity.classAndAttributeAndPseudoSelectors++;
		}


		private function cssId():void {
			_input.consume(1);
			var id:String = _input.consumeRegex(/[a-zA-Z\-_]+/);

			_normalizedSimpleSelectorSequence += "#" + id;

			var matcher:Matcher = new IdMatcher(id);
			_currentMatcherSequence.elementMatchers.push(matcher);

			_specificity.idSelector++;
		}


		private function pseudoElement():void {
			_input.consumeString("::");
			_pseudoElementName = _input.consumeRegex(/[a-zA-Z][\w\-]*/);

			_normalizedSimpleSelectorSequence += "::" + _pseudoElementName;

			_currentSelectorHasPseudoElement = true;

			_specificity.elementSelectorsAndPseudoElements++;
		}

		private function pseudoClass():void {
			_input.consumeString(":");
			_normalizedSimpleSelectorSequence += ":";
			var matcher:PseudoClassMatcher = functionalPseudo();

			_pseudoClassArguments = [];
			if (_input.isNext("(")) {
				pseudoClassArguments()
			}
			matcher.arguments = _pseudoClassArguments;

			_currentMatcherSequence.elementMatchers.push(matcher);

			//Special treatment for is-a pseudoClass classes: their specificity is always lower than that of element selectors
			if(matcher.pseudoClass is IsA) {
				_specificity.isAPseudoClassSelectors++;
			}
			else {
				_specificity.classAndAttributeAndPseudoSelectors++;
			}

		}


		private function functionalPseudo():PseudoClassMatcher {
			var pseudoClassName:String = _input.consumeRegex(/[a-zA-Z][\w\-]*/);
			_normalizedSimpleSelectorSequence += pseudoClassName;

			if (pseudoClassName != StaticPseudoClassName.IS_A && !_pseudoClassProvider.hasPseudoClass(pseudoClassName)) {
				throw new ParserError("Unknown pseudoClass-class '" + pseudoClassName + "' (In selector: '" + _originalSelector + "')");
			}

			var pseudoClass:PseudoClass = _pseudoClassProvider.getPseudoClass(pseudoClassName);

			var functionMatcher:PseudoClassMatcher = new PseudoClassMatcher(pseudoClass);
			return functionMatcher;

		}


		private function pseudoClassArguments():void {
			_input.consumeString("(");
			_normalizedSimpleSelectorSequence += "(";
			whitespace();
			pseudoClassArgument();
			_input.consumeString(")");
			_normalizedSimpleSelectorSequence += ")";

		}


		private function pseudoClassArgument():void {
			var argument:String = _input.consumeRegex(/[\w\+\-\.][\w\+\-\.\s]*/);
			_normalizedSimpleSelectorSequence += argument;

			_pseudoClassArguments.push(argument);

			whitespace();
			if (_input.isNext(","))
			{
				_input.consume(1);
				_normalizedSimpleSelectorSequence += ",";
				whitespace();
				pseudoClassArgument();
			}
		}


		private function attributeSelector():void {
			_input.consumeString("[");
			_normalizedSimpleSelectorSequence += "[";
			whitespace();
			attributeExpression();
			whitespace();
			_input.consumeString("]");
			_normalizedSimpleSelectorSequence += "]";

		}


		private function attributeExpression():void {
			whitespace();
			var property:String = propertyName();
			whitespace();

			var matcher:Matcher;
			if(_input.isNext("]")) {
				matcher = new AttributeExistsMatcher(property);
				_normalizedSimpleSelectorSequence += property;
			}
			else {
				var compareFunction:String = comparisonFunction();
				whitespace();
				var value:String = attributeValue();
				whitespace();

				matcher = matcherForCompareFunction(compareFunction, property, value);
				_normalizedSimpleSelectorSequence += property + compareFunction + "'" + value + "'";
			}

			_currentMatcherSequence.elementMatchers.push(matcher);
			_specificity.classAndAttributeAndPseudoSelectors++;
		}


		private function matcherForCompareFunction(compareFunction:String, property:String, value:String):Matcher {
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
			var value:String = _input.consumeRegex(new RegExp("[^" + quotationType + "]+"));
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



