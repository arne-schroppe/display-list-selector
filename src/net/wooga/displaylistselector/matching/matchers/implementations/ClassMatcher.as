package net.wooga.displaylistselector.matching.matchers.implementations {
	import net.wooga.displaylistselector.matching.matchers.IMatcher;
	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

	public class ClassMatcher implements IMatcher {
		private var _className:String;

		public function ClassMatcher(className:String) {
			_className = className;
		}

		public function isMatching(subject:ISelectorAdapter):Boolean {
			return subject.getClasses().indexOf(_className) != -1;
		}
	}
}
