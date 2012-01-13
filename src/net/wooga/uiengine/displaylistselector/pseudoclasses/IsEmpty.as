package net.wooga.uiengine.displaylistselector.pseudoclasses {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class IsEmpty implements IPseudoClass {

		public function isMatching(subject:DisplayObject):Boolean {
			return (subject as DisplayObjectContainer).numChildren == 0;
		}

		public function setArguments(arguments:Array):void {
			if (arguments.length != 0) {
				throw new ArgumentError("Wrong argument count");
			}
		}
	}
}
