package net.wooga.uiengine.displaylistselector.selectorstorage.keys {

	import flash.utils.getQualifiedClassName;

	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	public class TypeNameKey implements ISelectorTreeNodeKey {


		public function keyForSelector(parsedSelector:ParsedSelector):* {
			return parsedSelector.filterData.typeName;
		}

		public function keyForAdapter(adapter:ISelectorAdapter):* {
			return getQualifiedClassName(adapter.getAdaptedElement()).split("::").pop();
		}


		public function selectorHasKey(parsedSelector:ParsedSelector):Boolean {
			return parsedSelector.filterData.typeName && parsedSelector.filterData.typeName != "*";
		}

		public function get nullKey():* {
			return "*";
		}
	}
}
