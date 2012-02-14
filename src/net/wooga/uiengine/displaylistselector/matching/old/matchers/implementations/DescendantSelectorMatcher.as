package net.wooga.uiengine.displaylistselector.matching.old.matchers.implementations {
	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.matching.*;
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.ICombinator;
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.IMatcher;

	public class DescendantSelectorMatcher implements IMatcher, ICombinator {


		public function isMatching(subject:DisplayObject):Boolean {
			return true;
		}
	}
}
