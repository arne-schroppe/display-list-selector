package net.wooga.uiengine.displaylistselector.selectorstorage.keys {

	import flash.utils.getQualifiedClassName;

	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public class TypeNameKey implements ISelectorTreeNodeKey {


		public function keyForSelector(parsedSelector:ParsedSelector):* {
			return parsedSelector.filterData.typeName;
		}

		public function keyForAdapter(adapter:IStyleAdapter):* {
			return getQualifiedClassName(adapter.getAdaptedElement()).replace("::", ".");
		}


		public function selectorHasKey(parsedSelector:ParsedSelector):Boolean {
			return parsedSelector.filterData.typeName && parsedSelector.filterData.typeName != "*";
		}

		public function get nullKey():* {
			return "*";
		}
	}
}
