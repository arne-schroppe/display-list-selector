package net.wooga.selectors {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public interface IExternalPropertySource {
		function stringValueForProperty(subject:SelectorAdapter, name:String):String;

		function collectionValueForProperty(subject:SelectorAdapter, name:String):Array;
	}
}
