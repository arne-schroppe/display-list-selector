package net.wooga.displaylistselector.newtypes {

	import net.wooga.displaylistselector.ISpecificity;

	public interface SelectorDescription {
		function get specificity():ISpecificity;
		function get selectorString():String;
	}
}
