package net.wooga.displaylistselector {

	import net.wooga.displaylistselector.newtypes.SelectorGroup;
	import net.wooga.displaylistselector.newtypes.SelectorPool;
	import net.wooga.displaylistselector.pseudoclasses.IPseudoClass;

	public interface SelectorFactory {

		function initializeWith(rootObject:Object, externalPropertySource:IExternalPropertySource = null):void;

		function createSelector(selectorString:String):SelectorGroup;
		function createSelectorPool():SelectorPool;

		function addPseudoClass(className:String, pseudoClass:IPseudoClass):void;
	}
}
