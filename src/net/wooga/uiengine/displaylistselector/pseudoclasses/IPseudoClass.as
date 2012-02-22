package net.wooga.uiengine.displaylistselector.pseudoclasses {

	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public interface IPseudoClass {
		function setArguments(arguments:Array):void;

		function isMatching(subject:IStyleAdapter):Boolean;
	}
}
