package net.wooga.selectors.selectoradapter {

	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	//TODO (arneschroppe 23/06/2012) selectorevent doesn't need to be in this package. make an event based and a signal based adapter
	public class SelectorEvent extends Event {

		private static const PACKAGE:String = getQualifiedClassName(SelectorEvent) + ".";

		public static const ADD_PSEUDO_CLASS:String = PACKAGE + "ADD_PSEUDO_CLASS";
		public static const REMOVE_PSEUDO_CLASS:String = PACKAGE + "REMOVE_PSEUDO_CLASS";
		public static const SET_ID:String = PACKAGE + "SET_ID";
		public static const ADD_CLASS:String = PACKAGE + "ADD_CLASS";
		public static const REMOVE_CLASS:String = PACKAGE + "REMOVE_CLASS";

		private var _value:String;

		public function SelectorEvent(type:String, value:String) {
			super(type);
			_value = value;
		}

		public function get value():String {
			return _value;
		}
	}
}
