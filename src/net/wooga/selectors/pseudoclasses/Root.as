package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class Root implements IPseudoClass {

		private var _rootView:Object;


		public function Root(rootView:Object) {
			_rootView = rootView;
		}

		public function isMatching(subject:ISelectorAdapter):Boolean {
			return subject.getAdaptedElement() === _rootView;
		}

		public function setArguments(arguments:Array):void {
			if (arguments.length != 0) {
				throw new ArgumentError("Wrong argument count");
			}
		}
	}
}
