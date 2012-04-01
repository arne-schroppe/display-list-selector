package net.wooga.selectors.selectoradapter {
	public interface SelectorAdapter {
		function register(adaptedElement:Object):void;
		function unregister():void;

		
		function getElementClassName():String;
		function getQualifiedElementClassName():String;


		//TODO (arneschroppe 22/2/12) should we even use this? better not, the adapter should handle everything
		function getAdaptedElement():Object;
		function getParentElement():Object;


		function getId():String;
		function getClasses():Array;

		function hasPseudoClass(pseudoClassName:String):Boolean;

		function getElementIndex():int;

		//TODO (arneschroppe 2/26/12) make clear that these two deal with sibling elements
		function getNumberOfElements():int;
		function getElementAtIndex(index:int):Object;

		function isEmpty():Boolean;

		function getQualifiedInterfacesAndClasses():Vector.<String>;
		function getInterfacesAndClasses():Vector.<String>;
	}
}
