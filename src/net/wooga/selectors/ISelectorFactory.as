package net.wooga.selectors {

	import net.wooga.selectors.selectors.ISelectorGroup;
	import net.wooga.selectors.selectors.ISelectorPool;

	public interface ISelectorFactory {

		function initializeWith(rootObject:Object, externalPropertySource:IExternalPropertySource = null):void;

		function createSelector(selectorString:String):ISelectorGroup;
		function createSelectorPool():ISelectorPool;

		function addPseudoClass(className:String, pseudoClassType:Class, constructorArguments:Array=null):void;


		function setSelectorAdapterForType(adapterType:Class, objectType:Class):void;
		function setDefaultSelectorAdapter(adapterType:Class):void;

		function createSelectorAdapterFor(object:Object, overrideDefaultSelectorAdapter:Class = null):void;
		function removeSelectorAdapterOf(object:Object):void;
	}
}
