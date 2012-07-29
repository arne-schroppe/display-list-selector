package net.wooga.selectors.displaylist {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
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
		private var _matchingSubSelectors:Object = new Object();

		private static var _implementedTypeCache:Dictionary = new Dictionary();



		private var _pseudoClasses:Object = {};
		private var _classes:Object = {};
		private var _id:String = "";


		public function DisplayObjectSelectorAdapter() {
		}


		public function register(adaptedElement:Object):void {
			if(!(adaptedElement is DisplayObject)) {
				throw new ArgumentError("This adapter can only be used with DisplayObjects");
			}

			_adaptedElement = DisplayObject(adaptedElement);
			_adaptedElement.addEventListener(SelectorEvent.ADD_PSEUDO_CLASS, onAddPseudoClass);
			_adaptedElement.addEventListener(SelectorEvent.REMOVE_PSEUDO_CLASS, onRemovePseudoClass);
			_adaptedElement.addEventListener(SelectorEvent.SET_ID, onSetId);
			_adaptedElement.addEventListener(SelectorEvent.ADD_CLASS, onAddClass);
			_adaptedElement.addEventListener(SelectorEvent.REMOVE_CLASS, onRemoveClass);
			_adaptedElement.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}


		private function onRemovedFromStage(event:Event):void {
			invalidateCachedMatches();
			removeEventListeners();
		}

		private function removeEventListeners():void {
			//TODO (arneschroppe 29/07/2012) implement me. Use an AutoEventListenerManager or something like that. Something with a removeAll method
		}


		private function onAddPseudoClass(event:SelectorEvent):void {
			addPseudoClass(event.value);
		}



		private function onRemovePseudoClass(event:SelectorEvent):void {
			removePseudoClass(event.value);
		}



		private function onSetId(event:SelectorEvent):void {
			setId(event.value);
		}


		private function onAddClass(event:SelectorEvent):void {
			addClass(event.value);
		}

		private function onRemoveClass(event:SelectorEvent):void {
			removeClass(event.value);
		}


		public function addPseudoClass(pseudoClassName:String):void {
			_pseudoClasses[pseudoClassName] = true;
			invalidateCachedMatches();
		}

		public  function removePseudoClass(pseudoClassName:String):void {
			_pseudoClasses[pseudoClassName] = false;
			invalidateCachedMatches();
		}

		public function setId(value:String):void {
			_id = value;
			invalidateCachedMatches();
		}

		public function addClass(className:String):void {
			_classes[className] = true;
			invalidateCachedMatches();
		}

		public function removeClass(className:String):void {
			_classes[className] = false;
			invalidateCachedMatches();
		}


		public function unregister():void {
			_adaptedElement = null;
		}


		public function getAdaptedElement():Object {
			return _adaptedElement;
		}


		public function getId():String {
			return _id;
		}

		public function hasClass(className:String):Boolean {
			return _classes[className]
		}



		public function hasPseudoClass(pseudoClassName:String):Boolean {
			return _pseudoClasses[pseudoClassName];
		}

		public function getElementIndex():int {
			return _adaptedElement.parent ? _adaptedElement.parent.getChildIndex(_adaptedElement) : -1;
		}

		public function getNumberOfElementsInSameLevel():int {
			return _adaptedElement.parent ? _adaptedElement.parent.numChildren : 0;
		}

		public function getElementAtIndex(index:int):Object {
			return _adaptedElement.parent ? _adaptedElement.parent.getChildAt(index) : 0;
		}

		protected function get adaptedElement():DisplayObject {
			return _adaptedElement;
		}


		public function getParentElement():Object {
			return _adaptedElement.parent;
		}

		public function isEmpty():Boolean {
			return !(_adaptedElement is DisplayObjectContainer) || DisplayObjectContainer(_adaptedElement).numChildren == 0;
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




		public function hasSubSelectorMatchResult(subSelector:String):Boolean {
			return subSelector in _matchingSubSelectors;
		}

		public function getSubSelectorMatchResult(subSelector:String):Boolean {
			return _matchingSubSelectors[subSelector];
		}

		public function setSubSelectorMatchResult(subSelector:String, isMatching:Boolean):void {
			_matchingSubSelectors[subSelector] = isMatching;
		}

		public function invalidateCachedMatches():void {
			_matchingSubSelectors = new Object();
		}
	}
}
