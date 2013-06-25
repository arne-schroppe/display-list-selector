package net.wooga.selectors.selectors {


	public interface SelectorPool {
		function addSelector(selector:String):void
		function getSelectorsMatchingObject(object:Object):Vector.<Selector>;
		function getPseudoElementSelectorsMatchingObject(object:Object, pseudoElement:String):Vector.<Selector>;
	}
}
