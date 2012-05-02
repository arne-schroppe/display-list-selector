package net.wooga.selectors.usagepatterns {

	import net.wooga.selectors.specificity.Specificity;

	public interface SelectorDescription {
		function get specificity():Specificity;
		function get selectorString():String;

		function get isPseudoElementSelector():Boolean;
		function get pseudoElementName():String;

		function get selectorGroupString():String;
	}
}
