package net.wooga.displaylistselector.matching.matchers.implementations {
	import net.wooga.displaylistselector.matching.matchers.ICombinator;
	import net.wooga.displaylistselector.matching.matchers.IMatcher;
	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

	public class DescendantSelectorMatcher implements IMatcher, ICombinator {


		public function isMatching(subject:ISelectorAdapter):Boolean {
			return true;
		}
	}
}
