package net.wooga.uiengine.displaylistselector.tools {
	import net.wooga.uiengine.displaylistselector.ISpecificity;
	import net.wooga.uiengine.displaylistselector.parser.ParserResult;
	import net.wooga.uiengine.displaylistselector.selectorstorage.SelectorStorage;

	import org.as3commons.collections.framework.IComparator;
	import org.as3commons.collections.framework.IMap;

	public class SpecificityComparator implements IComparator {

		private var _stringToParsedSelectorMap:SelectorStorage;

		public function SpecificityComparator(stringToParsedSelectorMap:SelectorStorage) {
			_stringToParsedSelectorMap = stringToParsedSelectorMap;
		}

		public function compare(item1:*, item2:*):int {
			var specificity1:ISpecificity = (_stringToParsedSelectorMap.itemFor(item1) as ParserResult).specificity;
			var specificity2:ISpecificity = (_stringToParsedSelectorMap.itemFor(item2) as ParserResult).specificity;

			return specificity1.compare(specificity2);
		}
	}
}
