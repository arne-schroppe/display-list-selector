package net.wooga.displaylistselector.pseudoclasses {

	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

	public interface IPseudoClass {
		function setArguments(arguments:Array):void;

		function isMatching(subject:ISelectorAdapter):Boolean;
	}
}
