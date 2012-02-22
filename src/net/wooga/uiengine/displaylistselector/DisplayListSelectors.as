package net.wooga.uiengine.displaylistselector {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;

	import org.as3commons.collections.framework.ISet;

	public class DisplayListSelectors implements ISelectorTool {

		private var _selectors:AbstractSelectors;


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
			_selectors.createStyleAdapterFor(object as DisplayObject);
		}


		private function onRemovedFromStage(event:Event):void {
			var object:Object = event.target;
			_selectors.removeStyleAdapterOf(object as DisplayObject);
		}


		public function setStyleAdapterForType(adapterType:Class, objectType:Class):void {
			_selectors.setStyleAdapterForType(adapterType, objectType);
		}

		public function setDefaultStyleAdapter(adapterType:Class):void {
			_selectors.setDefaultStyleAdapter(adapterType);
		}

		public function createStyleAdapter(object:Object):void {
			_selectors.createStyleAdapterFor(object);
		}

		public function removeStyleAdapter(object:Object):void {
			_selectors.removeStyleAdapterOf(object);
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
