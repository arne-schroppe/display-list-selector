package net.wooga.uiengine.displaylistselector.pseudoclasses {

	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	public interface IPseudoClass {
		function setArguments(arguments:Array):void;

		function isMatching(subject:ISelectorAdapter):Boolean;
	}
}
