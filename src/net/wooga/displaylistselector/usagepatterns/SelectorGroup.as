package net.wooga.displaylistselector.usagepatterns {

	public interface SelectorGroup {
		
		function get selectors():Vector.<Selector>;
		function isAnySelectorMatching(object:Object):Boolean;
		
	}
}
