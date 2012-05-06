package net.wooga.selectors.matching.matchers.implementations {

	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.matching.combinators.MatcherFamily;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class ClassMatcher implements Matcher {
		private var _className:String;

		public function ClassMatcher(className:String) {
			_className = className;
		}

		public function isMatching(subject:SelectorAdapter):Boolean {
			return subject.getClasses().indexOf(_className) != -1;
		}

		public function get matcherFamily():MatcherFamily {
			return MatcherFamily.SIMPLE_MATCHER;
		}
	}
}
