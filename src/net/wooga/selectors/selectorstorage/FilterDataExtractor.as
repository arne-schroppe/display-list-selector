package net.wooga.selectors.selectorstorage {

	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.matching.matchersequence.MatcherSequence;
	import net.wooga.selectors.matching.matchers.implementations.IdMatcher;
	import net.wooga.selectors.matching.matchers.implementations.PseudoClassMatcher;
	import net.wooga.selectors.matching.matchers.implementations.TypeNameMatcher;
	import net.wooga.selectors.matching.combinators.MatcherFamily;
	import net.wooga.selectors.namespaces.selector_internal;
	import net.wooga.selectors.parser.FilterData;
	import net.wooga.selectors.pseudoclasses.IsA;
	import net.wooga.selectors.pseudoclasses.SettablePseudoClass;
	import net.wooga.selectors.pseudoclasses.names.PseudoClassName;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;

	//TODO (arneschroppe 06/04/2012) name of this class suggests, that we have a design error here
	public class FilterDataExtractor {

		use namespace selector_internal;

		public function getFilterData(selector:SelectorImpl):FilterData {

			var filterData:FilterData = new FilterData();

			var lastIdMatcher:IdMatcher = findMatcherInLastSimpleSelector(selector, IdMatcher) as IdMatcher;
			if (lastIdMatcher) {
				filterData.id = lastIdMatcher.id;
			}

			var lastTypeMatcher:TypeNameMatcher = findMatcherInLastSimpleSelector(selector, TypeNameMatcher) as TypeNameMatcher;
			var isA_PseudoClassInLastSimpleSelector:IsA = findIsAPseudoClassInLastSimpleSelector(selector);


			if(isA_PseudoClassInLastSimpleSelector) {
				filterData.typeName = isA_PseudoClassInLastSimpleSelector.typeName.split("::").pop();
				filterData.isImmediateType = false;
			}
			else if(lastTypeMatcher) {
				filterData.typeName = lastTypeMatcher.typeName ? lastTypeMatcher.typeName.split("::").pop() : null;
				filterData.isImmediateType = true;
			}

			filterData.hasHover = hasHoverPseudoClassInLastSimpleSelector(selector);

			return filterData;
		}


		//TODO (arneschroppe 3/25/12) we need a test for this, specifically to test that not just any SettablePseudoClass triggers the hasHover flag
		private function hasHoverPseudoClassInLastSimpleSelector(selector:SelectorImpl):Boolean {
			var matcherSequences:Vector.<MatcherSequence> = selector.matcherSequences;
			var matchers:Vector.<Matcher> = matcherSequences[matcherSequences.length-1].elementMatchers;
			for(var i:int = matchers.length-1; i >= 0 && !(Matcher(matchers[i]).matcherFamily == MatcherFamily.ANCESTOR_COMBINATOR); --i) {
				var matcher:Matcher = matchers[i];

				if(matcher.matcherFamily == MatcherFamily.ANCESTOR_COMBINATOR) {
					return false;
				}

				if( matcher is PseudoClassMatcher &&
						(matcher as PseudoClassMatcher).pseudoClass is SettablePseudoClass &&
						((matcher as PseudoClassMatcher).pseudoClass as SettablePseudoClass).pseudoClassName == PseudoClassName.HOVER) {
					return true;
				}
			}

			return false;
		}



		private function findIsAPseudoClassInLastSimpleSelector(selector:SelectorImpl):IsA {
			var matcherSequences:Vector.<MatcherSequence> = selector.matcherSequences;
			var matchers:Vector.<Matcher> = matcherSequences[matcherSequences.length-1].elementMatchers;

			for(var i:int = matchers.length-1; i >= 0 && !(Matcher(matchers[i]).matcherFamily == MatcherFamily.ANCESTOR_COMBINATOR); --i) {
				var matcher:Matcher = matchers[i];

				if(matcher.matcherFamily == MatcherFamily.ANCESTOR_COMBINATOR) {
					return null;
				}

				if( matcher is PseudoClassMatcher &&
						(matcher as PseudoClassMatcher).pseudoClass is IsA) {
					return (matcher as PseudoClassMatcher).pseudoClass as IsA;
				}
			}

			return null;
		}


		private function findMatcherInLastSimpleSelector(selector:SelectorImpl, MatcherType:Class):Matcher {

			var matcherSequences:Vector.<MatcherSequence> = selector.matcherSequences;
			var matchers:Vector.<Matcher> = matcherSequences[matcherSequences.length-1].elementMatchers;

			for(var i:int = matchers.length-1; i >= 0 && !(Matcher(matchers[i]).matcherFamily == MatcherFamily.ANCESTOR_COMBINATOR); --i) {
				var matcher:Matcher = matchers[i];
				if(matcher is MatcherType) {
					return matcher;
				}
			}

			return null;
		}
	}
}
