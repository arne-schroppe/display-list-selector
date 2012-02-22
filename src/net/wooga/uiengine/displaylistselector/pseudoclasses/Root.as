package net.wooga.uiengine.displaylistselector.pseudoclasses {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class Root implements IPseudoClass {

		private var _rootView:Object;


		public function Root(rootView:Object) {
			_rootView = rootView;
		}

		public function isMatching(subject:DisplayObject):Boolean {
			return subject === _rootView;
		}

		public function setArguments(arguments:Array):void {
			if (arguments.length != 0) {
				throw new ArgumentError("Wrong argument count");
			}
		}
	}
}
