package net.wooga.selectors.matching.matchers.implementations {

	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.pseudoclasses.PseudoClass;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class PseudoClassMatcher implements IMatcher {

		private var _pseudoClass:PseudoClass;


		public function get pseudoClass():PseudoClass {
			return _pseudoClass;
		}

		public function PseudoClassMatcher(pseudoClass:PseudoClass) {
			_pseudoClass = pseudoClass;
		}

		public function set arguments(arguments:Array):void {
			_pseudoClass.setArguments(arguments);
		}

		public function isMatching(subject:SelectorAdapter):Boolean {
			return _pseudoClass.isMatching(subject);
		}
	}
}
