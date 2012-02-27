package net.wooga.uiengine.displaylistselector.classnamealias {
	import flash.display.DisplayObjectContainer;
	import flash.utils.getQualifiedClassName;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMap;

	public class ClassNameAliasMap {

		private var _aliasMap:IMap = new Map();
		private var _rootObject:Object;
		private var _classNameInferenceStrategy:IClassNameInferenceStrategy;

		public function ClassNameAliasMap(rootObject:Object, classNameInferenceStrategy:IClassNameInferenceStrategy) {
			_rootObject = rootObject;
			_classNameInferenceStrategy = classNameInferenceStrategy;
		}

		public function setAlias(alias:String, fullyQualifiedClassName:String):void {

			if(_aliasMap.hasKey(alias) && fullyQualifiedClassName != _aliasMap.itemFor(alias)) {
				trace("Warning! Alias '" + alias + "' with value '" + _aliasMap.itemFor(alias) + "' is being overridden with value '" + fullyQualifiedClassName + "'");
				_aliasMap.replaceFor(alias, fullyQualifiedClassName);
			}
			else {
				_aliasMap.add(alias, fullyQualifiedClassName);
			}

		}

		public function classNameFor(alias:String):String {

			var result:String = _aliasMap.itemFor(alias);
			if(!result) {
				inferClassNameForAlias(alias);
				result = _aliasMap.itemFor(alias);
			}
			
			return result;
		}

		//TODO (arneschroppe 27/2/12) rewrite this in a type-agnostic fashion
		private function inferClassNameForAlias(alias:String):void {

			var iterator:DepthFirstDisplayListIterator = new DepthFirstDisplayListIterator(_rootObject as DisplayObjectContainer);
			while(iterator.hasNext()) {
				var displayObject:Object = iterator.next();
				if(_classNameInferenceStrategy.doesObjectMatchAlias(alias, displayObject)) {
					var inferredClassName:String = getQualifiedClassName(displayObject).replace("::", ".");
					setAlias(alias, inferredClassName);
					return;
				}
			}


			throw new Error("Could not infer a concrete class name for alias '" + alias + "'. Try to explicitly set a fully qualified class name for this alias.");

		}
	}
}
