package net.wooga.selectors.matching.matchers.implementations {

	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.matching.matchers.implementations.combinators.MatcherFamily;
	import net.wooga.selectors.pseudoclasses.IPseudoClass;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class PseudoClassMatcher implements IMatcher {

		private var _pseudoClass:IPseudoClass;


		public function get pseudoClass():IPseudoClass {
			return _pseudoClass;
		}

		public function PseudoClassMatcher(pseudoClass:IPseudoClass) {
			_pseudoClass = pseudoClass;
		}

		public function set arguments(arguments:Array):void {
			_pseudoClass.setArguments(arguments);
		}

		public function isMatching(subject:ISelectorAdapter):Boolean {
			return _pseudoClass.isMatching(subject);
		}

		public function get matcherFamily():MatcherFamily {
			return MatcherFamily.SIMPLE_MATCHER;
		}
	}
}
