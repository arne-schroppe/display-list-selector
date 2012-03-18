package net.wooga.selectors.matching.matchers.implementations {

	import net.wooga.selectors.matching.matchers.ICombinator;
	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class ChildSelectorMatcher implements IMatcher, ICombinator {

		public function isMatching(subject:ISelectorAdapter):Boolean {
			return true;
		}
	}
}
