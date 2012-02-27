package net.wooga.uiengine.displaylistselector.selectorstorage.keys {

	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public class HoverKey implements ISelectorTreeNodeKey {

		private static const NULL_KEY:String = "noHover";
		private static const HOVER_KEY:String = "hover";

		public function keyForSelector(parsedSelector:ParsedSelector):* {
			return parsedSelector.filterData.hasHover ? HOVER_KEY : NULL_KEY;
		}

		public function selectorHasKey(parsedSelector:ParsedSelector):Boolean {
			return parsedSelector.filterData.hasHover;
		}


		public function keyForAdapter(adapter:IStyleAdapter):* {
			return adapter.isHovered() ? HOVER_KEY : NULL_KEY;
		}


		public function get nullKey():* {
			return NULL_KEY;
		}
	}
}
