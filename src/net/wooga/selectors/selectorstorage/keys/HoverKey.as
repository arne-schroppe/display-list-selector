package net.wooga.selectors.selectorstorage.keys {

	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;
	import net.wooga.selectors.selector_internal;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	import org.as3commons.collections.framework.IMap;

	public class HoverKey implements ISelectorTreeNodeKey {

		use namespace selector_internal;

		private static const NULL_KEY:String = "noHover";
		private static const HOVER_KEY:String = "hover";

		public function keyForSelector(parsedSelector:SelectorImpl):String {
			return parsedSelector.filterData.hasHover ? HOVER_KEY : NULL_KEY;
		}

		public function selectorHasKey(parsedSelector:SelectorImpl):Boolean {
			return parsedSelector.filterData.hasHover;
		}


		public function keysForAdapter(adapter:ISelectorAdapter, nodes:IMap):Array {
			return [adapter.isHovered() ? HOVER_KEY : NULL_KEY];
		}


		public function get nullKey():String {
			return NULL_KEY;
		}

		public function invalidateCaches():void {
		}
	}
}
