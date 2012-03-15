package net.wooga.uiengine.displaylistselector.selectorstorage.keys {
	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	import org.as3commons.collections.framework.IMap;

	public class HoverKey implements ISelectorTreeNodeKey {

		private static const NULL_KEY:String = "noHover";
		private static const HOVER_KEY:String = "hover";

		public function keyForSelector(parsedSelector:ParsedSelector):String {
			return parsedSelector.filterData.hasHover ? HOVER_KEY : NULL_KEY;
		}

		public function selectorHasKey(parsedSelector:ParsedSelector):Boolean {
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
