package net.wooga.selectors.matching.matchers.implementations {

	import net.wooga.selectors.matching.matchers.ICombinator;
	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class DescendantSelectorMatcher implements IMatcher, ICombinator {


		public function isMatching(subject:SelectorAdapter):Boolean {
			return true;
		}
	}
}
