package net.wooga.selectors.selectors {

	import net.wooga.selectors.specificity.Specificity;

	public interface Selector {
		function get specificity():Specificity;
		function get selectorString():String;

		function get isPseudoElementSelector():Boolean;
		function get pseudoElementName():String;

		function get selectorGroupString():String;

		function isMatching(object:Object):Boolean;
	}
}
