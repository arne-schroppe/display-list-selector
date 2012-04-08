package net.wooga.selectors.matching.matchers.implementations.combinators {

	import net.wooga.selectors.matching.matchers.SiblingCombinator;
	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class AdjacentSiblingCombinator implements Matcher, SiblingCombinator {

		public function isMatching(subject:SelectorAdapter):Boolean {
			return true;
		}
	}
}
