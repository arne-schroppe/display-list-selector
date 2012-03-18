package net.wooga.displaylistselector.matching.matchers.implementations {

	import net.wooga.displaylistselector.matching.matchers.IMatcher;
	import net.wooga.displaylistselector.pseudoclasses.IPseudoClass;
	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

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
	}
}
