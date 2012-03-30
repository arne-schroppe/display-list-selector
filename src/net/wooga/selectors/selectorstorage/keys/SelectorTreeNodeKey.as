package net.wooga.selectors.selectorstorage.keys {

	import flash.utils.Dictionary;

	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;

	public interface SelectorTreeNodeKey {
		function keyForSelector(parsedSelector:SelectorImpl):String;

		function keysForAdapter(adapter:SelectorAdapter, nodes:Dictionary):Array;

		//function isKeyMatching(parsedSelector:ParsedSelector, key:*):Boolean;

		function selectorHasKey(parsedSelector:SelectorImpl):Boolean;

		function get nullKey():String;


		function invalidateCaches():void;
	}
}
