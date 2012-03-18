package net.wooga.selectors.displaylist {

	import net.wooga.selectors.*;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	import net.wooga.selectors.pseudoclasses.IPseudoClass;
	import net.wooga.selectors.usagepatterns.SelectorGroup;
	import net.wooga.selectors.usagepatterns.SelectorPool;

	public class DisplayListSelectors  {

		private var _selectorFactory:SelectorFactory;

		private var _rootObject:DisplayObjectContainer;

		public function DisplayListSelectors() {
			_selectorFactory = new SelectorFactoryImpl();
		}


		public function initializeWith(rootObject:DisplayObjectContainer, externalPropertySource:IExternalPropertySource = null, autoCreateAdapters:Boolean=true):void {
			_selectorFactory.initializeWith(rootObject, externalPropertySource);

			_rootObject = rootObject;
			if(autoCreateAdapters) {
				_rootObject.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, true);
				_rootObject.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, true);
			}
		}


		//TODO (arneschroppe 14/3/12) we don't need a decorator to automatically create style adapters, just write a small class for that
		private function onAddedToStage(event:Event):void {
			var object:Object = event.target;
			_selectorFactory.createStyleAdapterFor(object as DisplayObject);
		}


		private function onRemovedFromStage(event:Event):void {
			var object:Object = event.target;
			_selectorFactory.removeStyleAdapterOf(object as DisplayObject);
		}


		public function setStyleAdapterForType(adapterType:Class, objectType:Class):void {
			_selectorFactory.setStyleAdapterForType(adapterType, objectType);
		}

		public function setDefaultStyleAdapter(adapterType:Class):void {
			_selectorFactory.setDefaultStyleAdapter(adapterType);
		}


		public function addPseudoClass(className:String, pseudoClass:IPseudoClass):void {
			_selectorFactory.addPseudoClass(className, pseudoClass);
		}


		public function createSelector(selectorString:String):SelectorGroup {
			return _selectorFactory.createSelector(selectorString);
		}

		public function createSelectorPool():SelectorPool {
			return _selectorFactory.createSelectorPool();
		}

		public function createStyleAdapterFor(object:Object):void {
			_selectorFactory.createStyleAdapterFor(object);
		}

		public function removeStyleAdapterOf(object:Object):void {
			_selectorFactory.removeStyleAdapterOf(object);
		}
	}
}
