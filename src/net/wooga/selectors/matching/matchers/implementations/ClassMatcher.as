package net.wooga.selectors.matching.matchers.implementations {

	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

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
