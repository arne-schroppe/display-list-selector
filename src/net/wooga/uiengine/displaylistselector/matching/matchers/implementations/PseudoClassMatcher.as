package net.wooga.uiengine.displaylistselector.matching.matchers.implementations {
	import net.wooga.uiengine.displaylistselector.matching.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

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
