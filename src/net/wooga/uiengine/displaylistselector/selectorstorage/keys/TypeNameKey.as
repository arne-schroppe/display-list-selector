package net.wooga.uiengine.displaylistselector.selectorstorage.keys {

	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMap;

	public class TypeNameKey implements ISelectorTreeNodeKey {

		private var _typeToKeysMap:IMap = new Map();

		/*
		Note (asc 2011-03-14) We only check by class name, not by package. This means
		that we might get a few false positives (if there are elements in different packages
		with the same name), but those would be filtered out in the next matching step.
		*/

		public function keyForSelector(parsedSelector:ParsedSelector):String {
			return parsedSelector.filterData.typeName;
		}

		//TODO (arneschroppe 14/3/12) only use keys that actually exist in the tree and are isA-selectors
		public function keysForAdapter(adapter:ISelectorAdapter):Array {
			var className:String = getQualifiedClassName(adapter.getAdaptedElement());
			var keys:Array = getKeysForElement(className);
			if(!keys) {
				keys = createKeysForElement(adapter.getAdaptedElement(), className);
			}

			return keys;
		}

		private function createKeysForElement(element:Object, fqcn:String):Array {

			var keys:Array = [];

			keys.push(fqcn.split("::").pop());
			keys.push(nullKey);

			//get super-classes
			addTypes(describeType(element).extendsClass.@type, keys);
			addTypes(describeType(element).implementsInterface.@type, keys);

			_typeToKeysMap.add(fqcn, keys);

			return keys;
		}

		private function addTypes(types:XMLList, keys:Array):void {
			for each(var implementedType:String in types) {
				var className:String = implementedType.split("::").pop();
				keys.push(className);
			}
		}

		private function getKeysForElement(className:String):Array {
			return _typeToKeysMap.itemFor(className);
		}


		public function selectorHasKey(parsedSelector:ParsedSelector):Boolean {
			return parsedSelector.filterData.typeName && parsedSelector.filterData.typeName != "*";
		}

		public function get nullKey():String {
			return "*";
		}
	}
}
