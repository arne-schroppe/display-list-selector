package net.wooga.displaylistselector.usagepatterns {

	import net.wooga.displaylistselector.ISpecificity;

	public interface SelectorDescription {
		function get specificity():ISpecificity;
		function get selectorString():String;
		function get originalSelectorString():String;
	}
}
