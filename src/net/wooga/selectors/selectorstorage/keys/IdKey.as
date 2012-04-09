package net.wooga.selectors.selectorstorage.keys {

	import flash.utils.Dictionary;

	import net.wooga.selectors.namespace.selector_internal;
	import net.wooga.selectors.parser.FilterData;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;

	public class IdKey implements SelectorTreeNodeKey {

		use namespace selector_internal;

		private static const NULL_KEY:String = "$";

		public function keyForSelector(parsedSelector:SelectorImpl, filterData:FilterData):String {
			return filterData.id;
		}

		public function keysForAdapter(adapter:SelectorAdapter):Array {
			return [adapter.getId(), NULL_KEY];
		}

		public function selectorHasKey(parsedSelector:SelectorImpl, filterData:FilterData):Boolean {
			return !!filterData.id;
		}

		public function get nullKey():String {
			return NULL_KEY;
		}

		public function invalidateCaches():void {
		}
	}
}
