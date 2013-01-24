package net.wooga.selectors.selectorstorage.keys {

	import flash.utils.Dictionary;

	import net.wooga.selectors.namespace.selector_internal;
	import net.wooga.selectors.parser.FilterData;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;

	public class TypeNameKey implements SelectorTreeNodeKey {

		use namespace selector_internal;

		private var _typeToKeysMap:Dictionary = new Dictionary();

		private static const IS_A_PREFIX:String = "^";

		/*
		Note (asc 2011-03-14) We only check by class name, not by package. This means
		that we might get a few false positives (if there are elements in different packages
		with the same name), but those would be filtered out in the next matching step.
		*/

		public function keyForSelector(parsedSelector:SelectorImpl, filterData:FilterData):String {
			var prefix:String = filterData.isImmediateType ? "" : IS_A_PREFIX;
			return prefix + filterData.typeName;
		}


		public function keysForAdapter(adapter:SelectorAdapter, nodes:Dictionary):Array {
			var className:String = adapter.getQualifiedElementClassName();
			var keys:Array = getKeysForElement(className);
			if(!keys) {
				keys = createKeysForElement(adapter, nodes);
			}

			return keys;
		}

		private function getKeysForElement(className:String):Array {
			return _typeToKeysMap[className] as Array;
		}


		private function createKeysForElement(adapter:SelectorAdapter, nodes:Dictionary):Array {

			var keys:Array = [];

			var className:String = adapter.getElementClassName();
			var isASelectorKey:String = IS_A_PREFIX + className;

			addKeyIfItExistsInTree(className, keys, nodes);
			addKeyIfItExistsInTree(isASelectorKey, keys, nodes);
			addKeyIfItExistsInTree(nullKey, keys, nodes);

			//get super-classes
			addTypes(adapter.getInterfacesAndClasses(), keys, nodes);

			_typeToKeysMap[adapter.getQualifiedElementClassName()] = keys;

			return keys;
		}


		private function addKeyIfItExistsInTree(className:String, keys:Array, nodes:Dictionary):void {
			if (className in nodes) {
				keys.push(className);
			}
		}


		private function addTypes(types:Vector.<String>, keys:Array, nodes:Dictionary):void {
			for each(var implementedType:String in types) {
				addKeyIfItExistsInTree(IS_A_PREFIX + implementedType, keys, nodes);
			}
		}


		public function selectorHasKey(parsedSelector:SelectorImpl, filterData:FilterData):Boolean {
			return filterData.typeName && filterData.typeName != "*";
		}


		public function get nullKey():String {
			return "*";
		}


		//Because keys are based on what keys already exist in the tree, we need to recreate them if a selector is added
		public function invalidateCaches():void {
			_typeToKeysMap = new Dictionary();
		}
	}
}
