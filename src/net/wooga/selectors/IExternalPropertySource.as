package net.wooga.selectors {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	import org.as3commons.collections.Set;

	public interface IExternalPropertySource {
		function stringValueForProperty(subject:SelectorAdapter, name:String):String;

		//TODO (arneschroppe 12/1/12) change return type to Array?
		function collectionValueForProperty(subject:SelectorAdapter, name:String):Set;
	}
}
