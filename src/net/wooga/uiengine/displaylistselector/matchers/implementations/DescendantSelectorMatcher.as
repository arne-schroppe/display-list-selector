package net.wooga.uiengine.displaylistselector.matchers.implementations {
	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.matchers.*;

	public class DescendantSelectorMatcher implements IMatcher, ICombinator {


		public function isMatching(subject:DisplayObject):Boolean {
			return true;
		}
	}
}
