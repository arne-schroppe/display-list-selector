package net.wooga.displaylistselector.selectorstorage.keys {

	import net.wooga.displaylistselector.usagepatterns.implementations.SelectorImpl;
	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

	import org.as3commons.collections.framework.IMap;

	public interface ISelectorTreeNodeKey {
		function keyForSelector(parsedSelector:SelectorImpl):String;

		function keysForAdapter(adapter:ISelectorAdapter, nodes:IMap):Array;

		//function isKeyMatching(parsedSelector:ParsedSelector, key:*):Boolean;

		function selectorHasKey(parsedSelector:SelectorImpl):Boolean;

		function get nullKey():String;


		function invalidateCaches():void;
	}
}
