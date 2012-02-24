package net.wooga.uiengine.displaylistselector.selectorstorage.keys {
	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public class ElementKey implements ISelectorTreeNodeKey {
		public function ElementKey() {
		}

		public function keyForSelector(parsedSelector:ParsedSelector):* {
			return null;
		}

		public function keyForAdapter(adapter:IStyleAdapter):* {
			return null;
		}

		public function isKeyMatching(parsedSelector:ParsedSelector, key:*):Boolean {
			return false;
		}

		public function selectorHasKey(parsedSelector:ParsedSelector):Boolean {
			return false;
		}

		public function get nullKey():* {
			return "*";
		}
	}
}
