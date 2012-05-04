package net.wooga.selectors.matching.matchers.implementations.combinators {

	public class Combinator {

		private var _matcherFamily:MatcherFamily;
		private var _type:CombinatorType;

		public function Combinator(family:MatcherFamily, type:CombinatorType) {
			_matcherFamily = family;
			_type = type;
		}

		public function get type():CombinatorType {
			return _type;
		}

		public function get matcherFamily():MatcherFamily {
			return _matcherFamily;
		}
	}
}
