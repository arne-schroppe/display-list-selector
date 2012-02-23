package net.wooga.uiengine.displaylistselector.styleadapter {
	public interface IStyleAdapter {
		function register(adaptedElement:Object):void;
		function unregister(adaptedElement:Object):void;

		//function getParent():IStyleAdapter;
		//function setParent(value:IStyleAdapter):void;

		//TODO (arneschroppe 22/2/12) should we even use this? better not, the adapter should handle everything
		function getAdaptedElement():Object;

		function getId():String;
		function getClasses():Array;


		function getParentElement():Object;

		function getElementIndex():int;
		function getNumberOfElementsInContainer():int;
		function getSiblingElementAtIndex(index:int):Object;
		function isEmpty():Boolean;
	}
}
