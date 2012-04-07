package net.wooga.selectors.displaylist {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	import net.wooga.selectors.selectoradapter.*;

	public class DisplayObjectSelectorAdapter implements SelectorAdapter {

		private var _adaptedElement:DisplayObject;
		
		private var _elementClassName:String;
		private var _qualifiedElementClassName:String;
		private var _qualifiedInterfacesAndClasses:Vector.<String>;
		private var _interfacesAndClasses:Vector.<String>;


		private static var _implementedTypeCache:Dictionary = new Dictionary();

		//TODO (arneschroppe 2/26/12) rename groups to classes
		private static const CSS_CLASS_PARAMETER_NAME:String = "groups";


		private var _pseudoClasses:Object = {};

		public function DisplayObjectSelectorAdapter() {
		}


		public function register(adaptedElement:Object):void {
			if(!(adaptedElement is DisplayObject)) {
				throw new ArgumentError("This adapter can only be used with DisplayObjects");
			}

			_adaptedElement = DisplayObject(adaptedElement);
			_adaptedElement.addEventListener(SelectorPseudoClassEvent.ADD_PSEUDO_CLASS, onAddPseudoClass);
			_adaptedElement.addEventListener(SelectorPseudoClassEvent.REMOVE_PSEUDO_CLASS, onRemovePseudoClass);
		}

		private function onAddPseudoClass(event:SelectorPseudoClassEvent):void {
			_pseudoClasses[event.pseudoClassName] = true;
		}

		private function onRemovePseudoClass(event:SelectorPseudoClassEvent):void {
			_pseudoClasses[event.pseudoClassName] = false;
		}


		public function unregister():void {
			_adaptedElement = null;
		}


		public function getAdaptedElement():Object {
			return _adaptedElement;
		}


		public function getId():String {
			return _adaptedElement.name;
		}


		public function getClasses():Array {
			return (CSS_CLASS_PARAMETER_NAME in _adaptedElement) ? _adaptedElement[CSS_CLASS_PARAMETER_NAME] : [];
		}


		public function getElementIndex():int {
			return _adaptedElement.parent ? _adaptedElement.parent.getChildIndex(_adaptedElement) : -1;
		}

		public function getNumberOfElementsInContainer():int {
			return _adaptedElement.parent ? _adaptedElement.parent.numChildren : 0;
		}

		public function getElementAtIndex(index:int):Object {
			return _adaptedElement.parent ? _adaptedElement.parent.getChildAt(index) : 0;
		}

		protected function get adaptedElement():DisplayObject {
			return _adaptedElement;
		}

		protected function set adaptedElement(value:DisplayObject):void {
			_adaptedElement = value;
		}

		public function getParentElement():Object {
			return _adaptedElement.parent;
		}

		public function isEmpty():Boolean {
			return !(_adaptedElement is DisplayObjectContainer) || DisplayObjectContainer(_adaptedElement).numChildren == 0;
		}



		public function hasPseudoClass(pseudoClassName:String):Boolean {
			return _pseudoClasses[pseudoClassName];
		}

		public function getElementClassName():String {
			if(!_elementClassName) {
				extractClassNames()
			}

			return _elementClassName;
		}

		public function getQualifiedElementClassName():String {
			if(!_qualifiedElementClassName) {
				extractClassNames();
			}

			return _qualifiedElementClassName;
		}

		private function extractClassNames():void {
			_qualifiedElementClassName = getQualifiedClassName(adaptedElement);
			_elementClassName = _qualifiedElementClassName.split("::").pop();
		}


		public function getQualifiedInterfacesAndClasses():Vector.<String> {
			if(!_qualifiedInterfacesAndClasses) {
				extractImplementedTypes();
			}

			return _qualifiedInterfacesAndClasses;
		}



		public function getInterfacesAndClasses():Vector.<String> {
			if(!_interfacesAndClasses) {
				extractImplementedTypes();
			}

			return _interfacesAndClasses;
		}

		private function extractImplementedTypes():void {

			var className:String = getQualifiedElementClassName();
			if(className in _implementedTypeCache) {
				var cachedTypes:Array = _implementedTypeCache[className];

				_qualifiedInterfacesAndClasses = cachedTypes[0];
				_interfacesAndClasses = cachedTypes[1];
			}
			
			_qualifiedInterfacesAndClasses = new <String>[];
			_interfacesAndClasses = new <String>[];

			addImplementedTypes(describeType(_adaptedElement).extendsClass.@type);
			addImplementedTypes(describeType(_adaptedElement).implementsInterface.@type);


			createCacheEntryForImplementedTypes(className);
		}


		private function createCacheEntryForImplementedTypes(className:String):void {
			var cacheEntry:Array = [];
			cacheEntry.push(_qualifiedInterfacesAndClasses);
			cacheEntry.push(_interfacesAndClasses);

			_implementedTypeCache[className] = cacheEntry;
		}


		private function addImplementedTypes(types:XMLList):void {

			var className:String;
			for each(var type:XML in types) {
				className = type.toString();
				_qualifiedInterfacesAndClasses.push(className);
				_interfacesAndClasses.push(className.split("::").pop());
			}
		}
	}
}
