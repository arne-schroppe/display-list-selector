package net.wooga.selectors.selectorstorage.keys {

	import flash.utils.Dictionary;

	import net.wooga.selectors.namespace.selector_internal;
	import net.wooga.selectors.parser.FilterData;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;
	import net.wooga.selectors.selectors.implementations.Selector;

	public class IdKey implements ISelectorTreeNodeKey {

		use namespace selector_internal;

		private static const NULL_KEY:String = "$";

		public function keyForSelector(parsedSelector:Selector, filterData:FilterData):String {
			return filterData.id;
		}

		public function keysForAdapter(adapter:ISelectorAdapter, nodes:Dictionary):Array {
			return [adapter.getId(), NULL_KEY];
		}

		public function selectorHasKey(parsedSelector:Selector, filterData:FilterData):Boolean {
			return !!filterData.id;
		}

		public function get nullKey():String {
			return NULL_KEY;
		}

		public function invalidateCaches():void {
		}
	}
}
