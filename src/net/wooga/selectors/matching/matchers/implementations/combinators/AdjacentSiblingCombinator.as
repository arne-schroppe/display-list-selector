package net.wooga.selectors.matching.matchers.implementations.combinators {

	import net.wooga.selectors.matching.matchers.GenericSiblingCombinator;
	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class AdjacentSiblingCombinator implements Matcher, GenericSiblingCombinator {

		public function isMatching(subject:SelectorAdapter):Boolean {
			return true;
		}
	}
}
