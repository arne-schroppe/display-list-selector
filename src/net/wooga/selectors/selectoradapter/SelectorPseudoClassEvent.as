package net.wooga.selectors.selectoradapter {

	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	public class SelectorPseudoClassEvent extends Event {

		private static const PACKAGE:String = getQualifiedClassName(SelectorPseudoClassEvent) + ".";

		public static const ADD_PSEUDO_CLASS:String = PACKAGE + "ADD_PSEUDO_CLASS";
		public static const REMOVE_PSEUDO_CLASS:String = PACKAGE + "REMOVE_PSEUDO_CLASS";

		private var _pseudoClassName:String;

		public function SelectorPseudoClassEvent(type:String, pseudoClassName:String) {
			super(type);
			_pseudoClassName = pseudoClassName;
		}

		public function get pseudoClassName():String {
			return _pseudoClassName;
		}
	}
}
