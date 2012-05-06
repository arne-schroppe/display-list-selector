package net.wooga.selectors.matching.combinators {

	public class MatcherFamily {
		
		private var _value:String;

		public function MatcherFamily(value:String) {
			_value = value;
		}

		public static const ANCESTOR_COMBINATOR:MatcherFamily = new MatcherFamily("ANCESTOR_COMBINATOR");
		public static const SIBLING_COMBINATOR:MatcherFamily = new MatcherFamily("SIBLING_COMBINATOR");
		public static const SIMPLE_MATCHER:MatcherFamily = new MatcherFamily("SIMPLE_MATCHER");


		public function toString():String {
			return _value;
		}
	}
}
