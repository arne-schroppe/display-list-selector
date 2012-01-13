package net.wooga.uiengine.displaylistselector.matchers.implementations {
	import net.wooga.uiengine.displaylistselector.matchers.*;
	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;

	public class ClassNameMatcher implements IMatcher {

		private var _className:String;
		private var _matchAny:Boolean = false;

		public function ClassNameMatcher(className:String) {
			_className = className;
			if (_className == "*") {
				_matchAny = true;
			}
		}


		public function isMatching(subject:DisplayObject):Boolean {
			if (_matchAny || getQualifiedClassName(subject).split("::").pop() == _className) {
				return true;
			} else {
				return false;
			}
		}
	}
}
