package net.wooga.selectors.selectorstorage {

	import net.wooga.selectors.matching.matchers.ICombinator;
	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.matching.matchers.implementations.IdMatcher;
	import net.wooga.selectors.matching.matchers.implementations.PseudoClassMatcher;
	import net.wooga.selectors.matching.matchers.implementations.TypeNameMatcher;
	import net.wooga.selectors.pseudoclasses.IsA;
	import net.wooga.selectors.pseudoclasses.SettablePseudoClass;
	import net.wooga.selectors.pseudoclasses.names.PseudoClassName;
	import net.wooga.selectors.namespace.selector_internal;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;

	//TODO (arneschroppe 06/04/2012) name of this class suggests, that we have a design error here
	public class FilterDataExtractor {

		use namespace selector_internal;

		//TODO (arneschroppe 06/04/2012) don't store filterdata inside selector, but return as separate object
		public function setupFilterData(selector:SelectorImpl):void {

			if(selector.filterData.isInitialized) {
				return;
			}

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

			selector.filterData.isInitialized = true;
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
	}
}
