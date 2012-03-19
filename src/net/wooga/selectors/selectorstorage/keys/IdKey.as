package net.wooga.selectors.selectorstorage.keys {

	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;
	import net.wooga.selectors.selector_internal;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	import org.as3commons.collections.framework.IMap;

	public class IdKey implements SelectorTreeNodeKey {

		use namespace selector_internal;

		private static const NULL_KEY:String = "$$";

		public function keyForSelector(parsedSelector:SelectorImpl):String {
			return parsedSelector.filterData.id;
		}

		public function keysForAdapter(adapter:SelectorAdapter, nodes:IMap):Array {
			return [adapter.getId(), NULL_KEY];
		}

		public function selectorHasKey(parsedSelector:SelectorImpl):Boolean {
			return !!parsedSelector.filterData.id;
		}

		public function get nullKey():String {
			return NULL_KEY;
		}

		public function invalidateCaches():void {
		}
	}
}
