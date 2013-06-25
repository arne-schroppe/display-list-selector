package net.wooga.selectors.matching.matchers.implementations.combinators {

	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class Combinator implements IMatcher{

		private var _matcherFamily:MatcherFamily;
		private var _type:CombinatorType;

		public function Combinator(family:MatcherFamily, type:CombinatorType) {
			_matcherFamily = family;
			_type = type;
		}

		public function isMatching(subject:ISelectorAdapter):Boolean {
			return true;
		}

		public function get type():CombinatorType {
			return _type;
		}

		public function get matcherFamily():MatcherFamily {
			return _matcherFamily;
		}
	}
}
