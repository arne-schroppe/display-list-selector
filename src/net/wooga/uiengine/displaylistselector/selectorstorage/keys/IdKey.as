package net.wooga.uiengine.displaylistselector.selectorstorage.keys {
	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	public class IdKey implements ISelectorTreeNodeKey {

		private static const NULL_KEY:String = "$$";

		public function keyForSelector(parsedSelector:ParsedSelector):* {
			return parsedSelector.filterData.id;
		}

		public function keyForAdapter(adapter:ISelectorAdapter):* {
			return adapter.getId();
		}

		public function selectorHasKey(parsedSelector:ParsedSelector):Boolean {
			return !!parsedSelector.filterData.id;
		}

		public function get nullKey():* {
			return NULL_KEY;
		}
	}
}