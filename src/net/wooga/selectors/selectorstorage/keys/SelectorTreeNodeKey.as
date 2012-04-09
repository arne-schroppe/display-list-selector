package net.wooga.selectors.selectorstorage.keys {

	import flash.utils.Dictionary;

	import net.wooga.selectors.parser.FilterData;

	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;

	public interface SelectorTreeNodeKey {
		function keyForSelector(parsedSelector:SelectorImpl, filterData:FilterData):String;
		function selectorHasKey(parsedSelector:SelectorImpl, filterData:FilterData):Boolean;


		function keysForAdapter(adapter:SelectorAdapter):Array;


		function get nullKey():String;

		function invalidateCaches():void;
	}
}
