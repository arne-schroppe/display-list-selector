package net.wooga.selectors.selectors {

	public interface ISelectorGroup {

		function get length():int;
		function getSelectorAtIndex(index:int):ISelector;
		function isAnySelectorMatching(object:Object):Boolean;
		
	}
}
