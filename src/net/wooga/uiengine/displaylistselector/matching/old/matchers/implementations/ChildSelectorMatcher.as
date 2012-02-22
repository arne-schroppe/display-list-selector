package net.wooga.uiengine.displaylistselector.matching.old.matchers.implementations {
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.ICombinator;
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public class ChildSelectorMatcher implements IMatcher, ICombinator {

		public function isMatching(subject:IStyleAdapter):Boolean {
			return true;
		}
	}
}
