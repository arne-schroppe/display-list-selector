package net.wooga.selectors.selectorstorage.keys {

	import net.wooga.selectors.namespace.selector_internal;
	import net.wooga.selectors.parser.FilterData;
	import net.wooga.selectors.pseudoclasses.names.PseudoClassName;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;

	public class HoverKey implements SelectorTreeNodeKey {

		use namespace selector_internal;

		private static const NULL_KEY:String = "noHover";
		private static const HOVER_KEY:String = "hover";

		public function keyForSelector(parsedSelector:SelectorImpl, filterData:FilterData):String {
			return filterData.hasHover ? HOVER_KEY : NULL_KEY;
		}

		public function selectorHasKey(parsedSelector:SelectorImpl, filterData:FilterData):Boolean {
			return filterData.hasHover;
		}


		public function keysForAdapter(adapter:SelectorAdapter):Array {
			return [adapter.hasPseudoClass(PseudoClassName.hover) ? HOVER_KEY : NULL_KEY];
		}


		public function get nullKey():String {
			return NULL_KEY;
		}

		public function invalidateCaches():void {
		}
	}
}
