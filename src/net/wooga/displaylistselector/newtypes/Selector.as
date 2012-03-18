package net.wooga.displaylistselector.newtypes {
	import net.wooga.displaylistselector.ISpecificity;

	public interface Selector extends SelectorDescription {

		function isMatching(object:Object):Boolean;

	}
}
