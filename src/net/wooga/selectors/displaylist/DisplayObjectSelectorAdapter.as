package net.wooga.selectors.displaylist {

	import net.wooga.selectors.selectoradapter.*;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class DisplayObjectSelectorAdapter implements SelectorAdapter {

		private var _adaptedElement:DisplayObject;

		//TODO (arneschroppe 2/26/12) rename groups to classes
		private static const CSS_CLASS_PARAMETER_NAME:String = "groups";



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

		}

		private function onRemovePseudoClass(event:SelectorPseudoClassEvent):void {

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
			return false;
		}

		public function isActive():Boolean {
			return false;
		}

		public function isFocused():Boolean {
			return false;
		}
	}
}
