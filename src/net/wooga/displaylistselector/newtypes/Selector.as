package net.wooga.displaylistselector.newtypes {
	import net.wooga.displaylistselector.ISpecificity;

	public interface Selector {

		function isMatching(object:Object):Boolean;
		function get specificity():ISpecificity;
	}
}
