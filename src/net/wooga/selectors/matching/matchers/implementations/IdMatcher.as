package net.wooga.selectors.matching.matchers.implementations {

	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.matching.matchers.implementations.combinators.MatcherFamily;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class IdMatcher implements Matcher {
		private var _id:String;

		public function IdMatcher(id:String) {
			_id = id;
		}

		public function isMatching(subject:SelectorAdapter):Boolean {
			return subject.getId() == _id;
		}

		public function get id():String {
			return _id;
		}

		public function get matcherFamily():MatcherFamily {
			return MatcherFamily.SIMPLE_MATCHER;
		}
	}
}
