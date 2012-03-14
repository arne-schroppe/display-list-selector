package net.wooga.uiengine.displaylistselector.selectoradapter {
	public interface ISelectorAdapter {
		function register(adaptedElement:Object, delegate:ISelectorAdapterDelegate):void;
		function unregister():void;



		//TODO (arneschroppe 22/2/12) should we even use this? better not, the adapter should handle everything
		function getAdaptedElement():Object;
		function getParentElement():Object;


		function getId():String;
		function getClasses():Array;

		function isHovered():Boolean;
		function isActive():Boolean;


		function getElementIndex():int;

		//TODO (arneschroppe 2/26/12) make clear that these two deal with sibling elements
		function getNumberOfElements():int;
		function getElementAtIndex(index:int):Object;

		function isEmpty():Boolean;
	}
}