package net.wooga.selectors.usagepatterns {

	import net.wooga.selectors.specificity.Specificity;

	public interface SelectorDescription {
		function get specificity():Specificity;
		function get selectorString():String;

		//TODO (arneschroppe 07/04/2012) do we need this? we could also simply store this in the selectorgroup
		function get selectorGroupString():String;
	}
}
