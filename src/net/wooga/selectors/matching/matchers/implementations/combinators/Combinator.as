package net.wooga.selectors.matching.matchers.implementations.combinators {

	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class Combinator implements Matcher{

		private var _matcherFamily:MatcherFamily;
		private var _type:CombinatorType;

		public function Combinator(family:MatcherFamily, type:CombinatorType) {
			_matcherFamily = family;
			_type = type;
		}

		public function isMatching(subject:SelectorAdapter):Boolean {
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
