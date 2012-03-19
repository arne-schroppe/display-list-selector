package net.wooga.selectors.selectorstorage.keys {

	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	import org.as3commons.collections.framework.IMap;

	public interface SelectorTreeNodeKey {
		function keyForSelector(parsedSelector:SelectorImpl):String;

		function keysForAdapter(adapter:SelectorAdapter, nodes:IMap):Array;

		//function isKeyMatching(parsedSelector:ParsedSelector, key:*):Boolean;

		function selectorHasKey(parsedSelector:SelectorImpl):Boolean;

		function get nullKey():String;


		function invalidateCaches():void;
	}
}
