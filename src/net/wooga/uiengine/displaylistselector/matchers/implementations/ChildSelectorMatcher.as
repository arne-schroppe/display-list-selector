package net.wooga.uiengine.displaylistselector.matchers.implementations {
	import net.wooga.uiengine.displaylistselector.matchers.*;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class ChildSelectorMatcher implements IMatcher, ICombinator {

		public function isMatching(subject:DisplayObject):Boolean {
			if (subject == null || !subject is DisplayObjectContainer) {
				return false;
			}

			return true;
		}
	}
}
