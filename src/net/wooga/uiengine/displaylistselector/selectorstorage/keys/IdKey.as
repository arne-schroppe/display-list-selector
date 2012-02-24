package net.wooga.uiengine.displaylistselector.selectorstorage.keys {
	import net.wooga.uiengine.displaylistselector.parser.ParserResult;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public class IdKey implements ISelectorTreeNodeKey {

		public function keyForSelector(parsedSelector:ParserResult):* {
			return null;
		}

		public function keyForAdapter(adapter:IStyleAdapter):* {
			return null;
		}
	}
}
