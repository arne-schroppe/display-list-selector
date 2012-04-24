package net.wooga.selectors {

	import net.wooga.selectors.usagepatterns.SelectorGroup;
	import net.wooga.selectors.usagepatterns.SelectorPool;

	public interface SelectorFactory {

		function initializeWith(rootObject:Object, externalPropertySource:ExternalPropertySource = null):void;

		function createSelector(selectorString:String):SelectorGroup;
		function createSelectorPool():SelectorPool;

		function addPseudoClass(className:String, pseudoClassType:Class, constructorArguments:Array=null):void;


		function setSelectorAdapterForType(adapterType:Class, objectType:Class):void;
		function setDefaultSelectorAdapter(adapterType:Class):void;

		function createSelectorAdapterFor(object:Object, overrideDefaultSelectorAdapter:Class = null):void;
		function removeSelectorAdapterOf(object:Object):void;
	}
}
