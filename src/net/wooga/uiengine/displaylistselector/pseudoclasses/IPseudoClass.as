package net.wooga.uiengine.displaylistselector.pseudoclasses {

	import flash.display.DisplayObject;

	public interface IPseudoClass {
		function setArguments(arguments:Array):void;

		function isMatching(subject:DisplayObject):Boolean;
	}
}
