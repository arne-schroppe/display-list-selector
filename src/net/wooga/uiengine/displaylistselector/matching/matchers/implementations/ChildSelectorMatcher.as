package net.wooga.uiengine.displaylistselector.matching.matchers.implementations {
	import net.wooga.uiengine.displaylistselector.matching.matchers.ICombinator;
	import net.wooga.uiengine.displaylistselector.matching.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	public class ChildSelectorMatcher implements IMatcher, ICombinator {

		public function isMatching(subject:ISelectorAdapter):Boolean {
			return true;
		}
	}
}
