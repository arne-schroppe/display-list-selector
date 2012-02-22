package net.wooga.uiengine.displaylistselector {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;

	import net.wooga.uiengine.displaylistselector.selector.IStyleAdapter;
	import net.wooga.uiengine.displaylistselector.tools.Types;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.collections.framework.ISet;

	public class DisplayListSelectors implements ISelectorTool {

		private var _selectors:AbstractSelectors;

		private var _objectToStyleAdapterMap:IMap = new Map();
		private var _displayObjectTypeToStyleAdapterTypeMap:IMap = new Map();
		private var _defaultStyleAdapterType:Class;
		private var _rootObject:DisplayObjectContainer;

		public function DisplayListSelectors() {
			_selectors = new AbstractSelectors();
		}


		public function initializeWith(rootObject:DisplayObjectContainer, externalPropertySource:IExternalPropertySource = null, idAttribute:String = "name", classAttribute:String = "group", autoCreateAdapters:Boolean=true):void {
			_selectors.initializeWith(rootObject, externalPropertySource, idAttribute, classAttribute);

			_rootObject = rootObject;
			if(autoCreateAdapters) {
				_rootObject.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, true);
				_rootObject.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, true);
			}
			
		}


		private function onAddedToStage(event:Event):void {
			var object:Object = event.target;
			createStyleAdapter(object as DisplayObject);
		}


		private function onRemovedFromStage(event:Event):void {
			var object:Object = event.target;
			removeStyleAdapter(object as DisplayObject);
		}



		public function setStyleAdapterForType(adapterType:Class, displayObjectType:Class):void {
			checkAdapterType(adapterType);
			_displayObjectTypeToStyleAdapterTypeMap.add(getQualifiedClassName(displayObjectType), adapterType);
		}


		public function setDefaultStyleAdapter(adapterType:Class):void {
			checkAdapterType(adapterType);
			_defaultStyleAdapterType = adapterType;
		}




		private function checkAdapterType(adapterType:Class):void {
			if (!Types.doesTypeImplementInterface(adapterType, IStyleAdapter)) {
				throw new ArgumentError(getQualifiedClassName(adapterType) + " must implement " + getQualifiedClassName(IStyleAdapter) + " to be registered as an adapter");
			}
		}



		public function createStyleAdapter(object:DisplayObject):void {
			if(!_objectToStyleAdapterMap.hasKey(object)) {

				var SelectorClientClass:Class = getStyleAdapterClass(object);
				if(!SelectorClientClass) {
					//report("Warning! No selector client type registered for type " + getQualifiedClassName(object) + " and no default set!");
					return;
				}

				var selectorClient:IStyleAdapter = new SelectorClientClass();
				_objectToStyleAdapterMap.add(object, selectorClient);
				selectorClient.register(object);
			}
		}



		private function getStyleAdapterClass(object:DisplayObject):Class {
			var objectTypeName:String = getQualifiedClassName(object);
			var SelectorClientClass:Class = _displayObjectTypeToStyleAdapterTypeMap.itemFor(objectTypeName);
			if (!SelectorClientClass) {
				SelectorClientClass = _defaultStyleAdapterType;
			}
			return SelectorClientClass;
		}


		public function removeStyleAdapter(object:DisplayObject):void {

			if(_objectToStyleAdapterMap.hasKey(object)) {
				var selectorClient:IStyleAdapter = _objectToStyleAdapterMap.itemFor(object);
				selectorClient.unregister(object);
				_objectToStyleAdapterMap.removeKey(object);
			}
		}


		public function addSelector(selectorString:String):void {
			_selectors.addSelector(selectorString);
		}

		public function getSelectorsMatchingObject(object:Object):ISet {
			return _selectors.getSelectorsMatchingObject(object);
		}

		public function addPseudoClass(className:String, pseudoClass:IPseudoClass):void {
			_selectors.addPseudoClass(className, pseudoClass);
		}

		public function objectWasChanged(object:Object):void {
			_selectors.objectWasChanged(object);
		}
	}
}
