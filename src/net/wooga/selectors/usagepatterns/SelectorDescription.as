package net.wooga.selectors.usagepatterns {

	import net.wooga.selectors.Specificity;

	public interface SelectorDescription {
		function get specificity():Specificity;
		function get selectorString():String;
		function get originalSelectorString():String;
	}
}
