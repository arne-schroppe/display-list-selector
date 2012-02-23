package net.wooga.uiengine.displaylistselector {
	import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;

	import org.as3commons.collections.framework.ISet;

	public interface ISelectorTool {
		function addSelector(selectorString:String):void;

		function getSelectorsMatchingObject(object:Object):ISet;

		function setClassNameAlias(alias:String, fullyQualifiedClassName:String):void;

		function addPseudoClass(className:String, pseudoClass:IPseudoClass):void;

		function objectWasChanged(object:Object):void;
	}
}
