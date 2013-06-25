package net.wooga.selectors.selectors {


	public interface ISelectorPool {
		function addSelector(selector:String):void
		function getSelectorsMatchingObject(object:Object):Vector.<ISelector>;
		function getPseudoElementSelectorsMatchingObject(object:Object, pseudoElement:String):Vector.<ISelector>;
	}
}
