package net.wooga.displaylistselector {
	import net.wooga.displaylistselector.pseudoclasses.IPseudoClass;

	import org.as3commons.collections.framework.ISet;

	public interface ISelectorTool {
		function addSelector(selectorString:String):void;

		//TODO (arneschroppe 24/2/12) we should change the return type here to Vector.<String>
		function getSelectorsMatchingObject(object:Object):ISet;

		function addPseudoClass(className:String, pseudoClass:IPseudoClass):void;


		//TODO (arneschroppe 5/3/12) maybe also add:
		//function getSpecificityForSelector(selector:String):ISpecificity //selector must have been registered previously

	}
}
