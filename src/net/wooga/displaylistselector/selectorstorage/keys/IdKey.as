package net.wooga.displaylistselector.selectorstorage.keys {
	import net.wooga.displaylistselector.parser.ParsedSelector;
	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

	import org.as3commons.collections.framework.IMap;

	public class IdKey implements ISelectorTreeNodeKey {

		private static const NULL_KEY:String = "$$";

		public function keyForSelector(parsedSelector:ParsedSelector):String {
			return parsedSelector.filterData.id;
		}

		public function keysForAdapter(adapter:ISelectorAdapter, nodes:IMap):Array {
			return [adapter.getId(), NULL_KEY];
		}

		public function selectorHasKey(parsedSelector:ParsedSelector):Boolean {
			return !!parsedSelector.filterData.id;
		}

		public function get nullKey():String {
			return NULL_KEY;
		}

		public function invalidateCaches():void {
		}
	}
}
