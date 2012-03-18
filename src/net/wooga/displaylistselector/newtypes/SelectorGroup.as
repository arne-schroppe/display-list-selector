package net.wooga.displaylistselector.newtypes {

	public interface SelectorGroup {
		
		function get selectors():Vector.<Selector>;
		function isAnySelectorMatching(object:Object):Boolean;
		
	}
}
