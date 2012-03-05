package net.wooga.uiengine.displaylistselector.selectoradapter {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	public class SelectorAdapterEvent extends Event {

		private static const PACKAGE:String = getQualifiedClassName(SelectorAdapterEvent) + ".";
		//public static const SET_AUTOMATIC_MOUSE_STATE_MONITORING:String = PACKAGE + "SET_AUTOMATIC_MOUSE_STATE_MONITORING";
		public static const SET_HOVER_STATE:String = PACKAGE + "SET_HOVER_STATE";
		public static const SET_ACTIVE_STATE:String = PACKAGE + "SET_ACTIVE_STATE";

		private var _isEnabled:Boolean;

		public function SelectorAdapterEvent(type:String, isEnabled:Boolean) {
			super(type);
			_isEnabled = isEnabled;
		}

		public function get isEnabled():Boolean {
			return _isEnabled;
		}
	}
}
