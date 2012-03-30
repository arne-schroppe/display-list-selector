package net.wooga.selectors.selectorstorage.keys {

	import flash.utils.Dictionary;

	import net.wooga.selectors.pseudoclasses.names.PseudoClassName;
	import net.wooga.selectors.selector_internal;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;

	public class HoverKey implements SelectorTreeNodeKey {

		use namespace selector_internal;

		private static const NULL_KEY:String = "noHover";
		private static const HOVER_KEY:String = "hover";

		public function keyForSelector(parsedSelector:SelectorImpl):String {
			return parsedSelector.filterData.hasHover ? HOVER_KEY : NULL_KEY;
		}

		public function selectorHasKey(parsedSelector:SelectorImpl):Boolean {
			return parsedSelector.filterData.hasHover;
		}


		public function keysForAdapter(adapter:SelectorAdapter, nodes:Dictionary):Array {
			return [adapter.hasPseudoClass(PseudoClassName.hover) ? HOVER_KEY : NULL_KEY];
		}


		public function get nullKey():String {
			return NULL_KEY;
		}

		public function invalidateCaches():void {
		}
	}
}
