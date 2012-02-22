package net.wooga.uiengine.displaylistselector.selector {
	import net.wooga.uiengine.displaylistselector.*;
	public interface ISelector {
		function get selectorString():String;

		function get specificity():ISpecificity;
	}
}
