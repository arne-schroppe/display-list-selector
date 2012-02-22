package net.wooga.uiengine.displaylistselector.matching.old.matchers.implementations {
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public class HasClassMatcher implements IMatcher {
		private var _className:String;

		public function HasClassMatcher(className:String) {
			_className = className;
		}

		public function isMatching(subject:IStyleAdapter):Boolean {
			return subject.getClasses().indexOf(_className) != -1;
		}
	}
}
