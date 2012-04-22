package net.wooga.selectors.displaylist {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	import net.wooga.selectors.*;

	public class DisplayListSelectorFactory extends AbstractSelectorFactory {


		private var _rootObject:DisplayObjectContainer;

		private var _autoCreateAdapters:Boolean;


		public function DisplayListSelectorFactory(autoCreateAdapters:Boolean=true) {
			_autoCreateAdapters = autoCreateAdapters;
		}

		override public function initializeWith(rootObject:Object, externalPropertySource:ExternalPropertySource = null):void {
			super.initializeWith(rootObject, externalPropertySource);

			setDefaultSelectorAdapter(DisplayObjectSelectorAdapter);

			_rootObject = DisplayObjectContainer(rootObject);
			if(_autoCreateAdapters) {
				_rootObject.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, true);
				_rootObject.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, true);
			}
		}

		private function onAddedToStage(event:Event):void {
			var object:Object = event.target;
			createSelectorAdapterFor(object as DisplayObject);
		}


		private function onRemovedFromStage(event:Event):void {
			var object:Object = event.target;
			removeSelectorAdapterOf(object as DisplayObject);
		}



	}
}
