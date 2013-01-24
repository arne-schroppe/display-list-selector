package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public interface PseudoClass {
		function setArguments(arguments:Array):void;

		function isMatching(subject:SelectorAdapter):Boolean;
	}
}
