package net.wooga.uiengine.displaylistselector.matching.old.matchers.implementations {
	import net.wooga.uiengine.displaylistselector.matching.*;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import net.wooga.uiengine.displaylistselector.matching.old.matchers.ICombinator;

	import net.wooga.uiengine.displaylistselector.matching.old.matchers.IMatcher;

	public class ChildSelectorMatcher implements IMatcher, ICombinator {

		public function isMatching(subject:DisplayObject):Boolean {
			if (subject == null || !subject is DisplayObjectContainer) {
				return false;
			}

			return true;
		}
	}
}
