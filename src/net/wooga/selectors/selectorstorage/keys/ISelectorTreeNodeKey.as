package net.wooga.selectors.selectorstorage.keys {

	import flash.utils.Dictionary;

	import net.wooga.selectors.parser.FilterData;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;
	import net.wooga.selectors.selectors.implementations.Selector;

	public interface ISelectorTreeNodeKey {
		function keyForSelector(parsedSelector:Selector, filterData:FilterData):String;
		function selectorHasKey(parsedSelector:Selector, filterData:FilterData):Boolean;


		function keysForAdapter(adapter:ISelectorAdapter, nodes:Dictionary):Array;


		function get nullKey():String;

		function invalidateCaches():void;
	}
}
