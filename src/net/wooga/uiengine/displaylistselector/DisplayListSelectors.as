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


		public function initializeWith(rootObject:DisplayObjectContainer, externalPropertySource:IExternalPropertySource = null, autoCreateAdapters:Boolean=true):void {
			_selectors.initializeWith(rootObject, externalPropertySource);

			_rootObject = rootObject;
			if(autoCreateAdapters) {
				_rootObject.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, true);
				_rootObject.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, true);
			}
			
		}


		//TODO (arneschroppe 14/3/12) we don't need a decorator to automatically create style adapters, just write a small class for that
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


	}
}
