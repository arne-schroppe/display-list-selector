package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public interface IPseudoClass {
		function setArguments(arguments:Array):void;

		function isMatching(subject:ISelectorAdapter):Boolean;
	}
}
