package net.wooga.selectors {

	import net.wooga.selectors.usagepatterns.SelectorGroup;
	import net.wooga.selectors.usagepatterns.SelectorPool;
	import net.wooga.selectors.pseudoclasses.PseudoClass;

	public interface SelectorFactory {

		function initializeWith(rootObject:Object, externalPropertySource:IExternalPropertySource = null):void;

		function createSelector(selectorString:String):SelectorGroup;
		function createSelectorPool():SelectorPool;

		function addPseudoClass(className:String, pseudoClass:PseudoClass):void;


		function setStyleAdapterForType(adapterType:Class, objectType:Class):void;
		function setDefaultStyleAdapter(adapterType:Class):void;

		function createStyleAdapterFor(object:Object):void;
		function removeStyleAdapterOf(object:Object):void;
	}
}
