package net.wooga.displaylistselector.usagepatterns {
	public interface SelectorPool {

		function addSelector(selector:String):void
		function getSelectorsMatchingObject(object:Object):Vector.<SelectorDescription>;
	}
}
