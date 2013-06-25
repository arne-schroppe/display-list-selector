package net.wooga.selectors.selectorstorage.keys {

	import flash.utils.Dictionary;

	import net.wooga.selectors.namespace.selector_internal;
	import net.wooga.selectors.parser.FilterData;
	import net.wooga.selectors.pseudoclasses.names.PseudoClassName;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;
	import net.wooga.selectors.selectors.implementations.Selector;

	public class HoverKey implements ISelectorTreeNodeKey {

		use namespace selector_internal;

		private static const NULL_KEY:String = "noHover";
		private static const HOVER_KEY:String = "hover";

		public function keyForSelector(parsedSelector:Selector, filterData:FilterData):String {
			return filterData.hasHover ? HOVER_KEY : NULL_KEY;
		}

		public function selectorHasKey(parsedSelector:Selector, filterData:FilterData):Boolean {
			return filterData.hasHover;
		}


		//TODO (arneschroppe 22/04/2012) why dont we have to specify NULL_KEY in the first case?
		public function keysForAdapter(adapter:ISelectorAdapter, nodes:Dictionary):Array {
			return adapter.hasPseudoClass(PseudoClassName.HOVER) ?  [HOVER_KEY] : [NULL_KEY];
		}


		public function get nullKey():String {
			return NULL_KEY;
		}

		public function invalidateCaches():void {
		}
	}
}
