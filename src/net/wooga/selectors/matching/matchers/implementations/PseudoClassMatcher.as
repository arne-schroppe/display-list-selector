package net.wooga.selectors.matching.matchers.implementations {

	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.matching.combinators.MatcherFamily;
	import net.wooga.selectors.pseudoclasses.PseudoClass;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class PseudoClassMatcher implements Matcher {

		private var _pseudoClass:PseudoClass;



		public function PseudoClassMatcher(pseudoClass:PseudoClass) {
			_pseudoClass = pseudoClass;
		}


		public function get pseudoClass():PseudoClass {
			return _pseudoClass;
		}


		public function set arguments(arguments:Array):void {
			_pseudoClass.setArguments(arguments);
		}

		public function isMatching(subject:SelectorAdapter):Boolean {
			return _pseudoClass.isMatching(subject);
		}

		public function get matcherFamily():MatcherFamily {
			return MatcherFamily.SIMPLE_MATCHER;
		}
	}
}
