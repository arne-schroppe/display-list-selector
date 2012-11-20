package net.wooga.selectors {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	//TODO (arneschroppe 19/11/2012) rename this to PropertyProvider … but this has to be rethought anyway
	public interface ExternalPropertySource {
		function stringValueForProperty(subject:SelectorAdapter, name:String):String;

		function collectionValueForProperty(subject:SelectorAdapter, name:String):Array;
	}
}
