package net.wooga.selectors.selectorstorage.keys {

	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	import net.wooga.selectors.selector_internal;
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

		public function keyForSelector(parsedSelector:SelectorImpl):String {
			var prefix:String = parsedSelector.filterData.isImmediateType ? "" : IS_A_PREFIX;
			return prefix + parsedSelector.filterData.typeName;
		}

		//TODO (arneschroppe 14/3/12) only use keys that actually exist in the tree and are isA-selectors
		public function keysForAdapter(adapter:SelectorAdapter, nodes:Dictionary):Array {
			var className:String = getQualifiedClassName(adapter.getAdaptedElement());
			var keys:Array = getKeysForElement(className);
			if(!keys) {
				keys = createKeysForElement(adapter.getAdaptedElement(), className, nodes);
			}

			return keys;
		}

		private function getKeysForElement(className:String):Array {
			return _typeToKeysMap[className] as Array;
		}


		private function createKeysForElement(element:Object, fqcn:String, nodes:Dictionary):Array {

			var keys:Array = [];

			var className:String = fqcn.split("::").pop();
			var isASelectorKey:String = IS_A_PREFIX + className;

			addKeyIfItExistsInTree(className, keys, nodes);
			addKeyIfItExistsInTree(isASelectorKey, keys, nodes);
			addKeyIfItExistsInTree(nullKey, keys, nodes);

			//TODO (arneschroppe 30/3/12) this is extremely slow!
			//get super-classes
			addTypes(describeType(element).extendsClass.@type, keys, nodes);
			addTypes(describeType(element).implementsInterface.@type, keys, nodes);

			_typeToKeysMap[fqcn] = keys;

			return keys;
		}


		private function addKeyIfItExistsInTree(className:String, keys:Array, nodes:Dictionary):void {
			if (nodes.hasOwnProperty(className)) {
				keys.push(className);
			}
		}


		private function addTypes(types:XMLList, keys:Array, nodes:Dictionary):void {
			for each(var implementedType:String in types) {
				var className:String = implementedType.split("::").pop();

				addKeyIfItExistsInTree(IS_A_PREFIX + className, keys, nodes);
			}
		}


		public function selectorHasKey(parsedSelector:SelectorImpl):Boolean {
			return parsedSelector.filterData.typeName && parsedSelector.filterData.typeName != "*";
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
