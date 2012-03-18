package net.wooga.displaylistselector.selectorstorage.keys {

	import net.wooga.displaylistselector.usagepatterns.implementations.SelectorImpl;
	import net.wooga.displaylistselector.selector_internal;
	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

	import org.as3commons.collections.framework.IMap;

	public class IdKey implements ISelectorTreeNodeKey {

		use namespace selector_internal;

		private static const NULL_KEY:String = "$$";

		public function keyForSelector(parsedSelector:SelectorImpl):String {
			return parsedSelector.filterData.id;
		}

		public function keysForAdapter(adapter:ISelectorAdapter, nodes:IMap):Array {
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
