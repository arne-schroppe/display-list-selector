package net.wooga.uiengine.displaylistselector.selectorstorage.keys {

	import flash.utils.getQualifiedClassName;

	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	public class TypeNameKey implements ISelectorTreeNodeKey {

		/*
		Note (asc 2011-03-14) We only check by class name, not by package. This means
		that we might get a few false positives (if there are elements in different packages
		with the same name), but those would be filtered out in the next matching step.
		*/

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
