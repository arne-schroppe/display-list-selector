package net.wooga.uiengine.displaylistselector.matching.matchers.implementations {
	import net.wooga.uiengine.displaylistselector.matching.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public class ClassMatcher implements IMatcher {
		private var _className:String;

		public function ClassMatcher(className:String) {
			_className = className;
		}

		public function isMatching(subject:IStyleAdapter):Boolean {
			return subject.getClasses().indexOf(_className) != -1;
		}
	}
}
