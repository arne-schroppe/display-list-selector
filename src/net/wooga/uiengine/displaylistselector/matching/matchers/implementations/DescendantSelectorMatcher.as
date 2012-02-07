package net.wooga.uiengine.displaylistselector.matching.matchers.implementations {
	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.matching.*;
	import net.wooga.uiengine.displaylistselector.matching.matchers.ICombinator;
	import net.wooga.uiengine.displaylistselector.matching.matchers.IMatcher;

	public class DescendantSelectorMatcher implements IMatcher, ICombinator {


		public function isMatching(subject:DisplayObject):Boolean {
			return true;
		}
	}
}
