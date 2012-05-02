package net.wooga.selectors.usagepatterns {


	public interface SelectorPool {
		function addSelector(selector:String):void
		function getSelectorsMatchingObject(object:Object):Vector.<SelectorDescription>;
		function getPseudoElementSelectorsMatchingObject(object:Object, pseudoElement:String):Vector.<SelectorDescription>;
	}
}
