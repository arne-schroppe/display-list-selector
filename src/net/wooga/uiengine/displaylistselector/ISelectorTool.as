package net.wooga.uiengine.displaylistselector {
	import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;

	import org.as3commons.collections.framework.ISet;

	public interface ISelectorTool {
		function addSelector(selectorString:String):void;

		//TODO (arneschroppe 24/2/12) we should change the return type here to Vector.<String>
		function getSelectorsMatchingObject(object:Object):ISet;

		function addPseudoClass(className:String, pseudoClass:IPseudoClass):void;

		function objectWasChanged(object:Object):void;
	}
}
