package net.wooga.uiengine.displaylistselector.selectoradapter {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class DisplayObjectSelectorAdapter implements ISelectorAdapter {

		private var _adaptedElement:DisplayObject;

		//TODO (arneschroppe 2/26/12) rename groups to classes
		private static const CSS_CLASS_PARAMETER_NAME:String = "groups";
		private var _isHovered:Boolean;
		private var _isActive:Boolean;
		private var _delegate:ISelectorAdapterDelegate;

		//private static const CSS_HOVER_PARAMETER_NAME:String = "isMouseOver";
		//private static const CSS_ACTIVE_PARAMETER_NAME:String = "isMouseDown";

		public function DisplayObjectSelectorAdapter() {
		}


		public function register(adaptedElement:Object, delegate:ISelectorAdapterDelegate):void {
			if(!(adaptedElement is DisplayObject)) {
				throw new ArgumentError("This adapter can only be used with DisplayObjects");
			}

			_delegate = delegate;
			_adaptedElement = DisplayObject(adaptedElement);
			_adaptedElement.addEventListener(SelectorAdapterEvent.SET_HOVER_STATE, onSetHoverState)
		}

		private function onSetHoverState(event:SelectorAdapterEvent):void {
			_isHovered = event.isEnabled;
			_delegate.objectStateHasChanged(this);
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

		public function getNumberOfElements():int {
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

		public function isHovered():Boolean {
			//return (CSS_HOVER_PARAMETER_NAME in _adaptedElement) ? _adaptedElement[CSS_HOVER_PARAMETER_NAME] : false;;
			return _isHovered;
		}

		public function isActive():Boolean {
			//return (CSS_ACTIVE_PARAMETER_NAME in _adaptedElement) ? _adaptedElement[CSS_CLASS_PARAMETER_NAME] : false;;
			return _isActive;
		}
	}
}
