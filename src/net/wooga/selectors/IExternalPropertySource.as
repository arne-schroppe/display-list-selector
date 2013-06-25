package net.wooga.selectors {

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public interface IExternalPropertySource {
		function stringValueForProperty(subject:ISelectorAdapter, name:String):String;

		function collectionValueForProperty(subject:ISelectorAdapter, name:String):Array;
	}
}
