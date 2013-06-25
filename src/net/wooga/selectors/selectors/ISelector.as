package net.wooga.selectors.selectors {

	import net.wooga.selectors.specificity.ISpecificity;

	public interface ISelector {
		function get specificity():ISpecificity;
		function get selectorString():String;

		function get isPseudoElementSelector():Boolean;
		function get pseudoElementName():String;

		function get selectorGroupString():String;

		function isMatching(object:Object):Boolean;
	}
}
