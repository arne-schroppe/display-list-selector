package net.wooga.uiengine.displaylistselector {
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class DisplayListSelectorEvent extends Event {


		public static const OBJECT_WAS_ADDED:String = "object_was_added";
		public static const OBJECT_WAS_CHANGED:String = "object_was_changed";

		private var _object:DisplayObject;

		public function DisplayListSelectorEvent(type:String, object:DisplayObject, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			_object = object;
		}

		public function get object():DisplayObject {
			return _object;
		}
	}
}
