package net.wooga.selectors.usagepatterns {

	public interface SelectorGroup {

		function get length():int;
		function getSelectorAtIndex(index:int):Selector;
		function isAnySelectorMatching(object:Object):Boolean;
		
	}
}
