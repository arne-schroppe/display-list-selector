package net.wooga.selectors.matching.matchers.implementations.combinators {

	import net.wooga.selectors.matching.matchers.GenericDescendantCombinator;
	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class ChildCombinator implements Matcher, GenericDescendantCombinator {

		public function isMatching(subject:SelectorAdapter):Boolean {
			return true;
		}
	}
}
