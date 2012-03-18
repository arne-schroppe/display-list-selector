package net.wooga.displaylistselector.pseudoclasses {

	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

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
