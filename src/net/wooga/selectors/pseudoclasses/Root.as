package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class Root implements PseudoClass {

		private var _rootView:Object;


		public function Root(rootView:Object) {
			_rootView = rootView;
		}

		public function isMatching(subject:SelectorAdapter):Boolean {
			return subject.getAdaptedElement() === _rootView;
		}

		public function setArguments(arguments:Array):void {
			if (arguments.length != 0) {
				throw new ArgumentError("Wrong argument count");
			}
		}
	}
}
