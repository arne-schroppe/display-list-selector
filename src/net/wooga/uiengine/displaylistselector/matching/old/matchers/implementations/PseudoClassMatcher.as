package net.wooga.uiengine.displaylistselector.matching.old.matchers.implementations {
	import net.wooga.uiengine.displaylistselector.matching.*;

	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.matching.old.matchers.IMatcher;

	import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;

	public class PseudoClassMatcher implements IMatcher {

		private var _pseudoClass:IPseudoClass;


		public function get pseudoClass():IPseudoClass {
			return _pseudoClass;
		}

		public function PseudoClassMatcher(pseudoClass:IPseudoClass) {
			_pseudoClass = pseudoClass;
		}

		public function set arguments(arguments:Array):void {
			_pseudoClass.setArguments(arguments);
		}

		public function isMatching(subject:DisplayObject):Boolean {
			return _pseudoClass.isMatching(subject);
		}
	}
}