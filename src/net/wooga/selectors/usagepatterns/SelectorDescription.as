package net.wooga.selectors.usagepatterns {

	import net.wooga.selectors.ISpecificity;

	public interface SelectorDescription {
		function get specificity():ISpecificity;
		function get selectorString():String;
		function get originalSelectorString():String;
	}
}
