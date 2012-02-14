package net.wooga.uiengine.displaylistselector.selector {
	import net.wooga.uiengine.displaylistselector.*;
	public interface Selector {
		function get selectorString():String;

		function get specificity():ISpecificity;
	}
}
