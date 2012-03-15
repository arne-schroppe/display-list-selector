package net.wooga.displaylistselector.newtypes {
	public interface SelectorPool {

		function addSelector(selector:String):void
		function getSelectorsMatchingObject(object:Object):Vector.<Selector>;
		function getSelectorStringsMatchingObject(object:Object):Vector.<String>;
	}
}
