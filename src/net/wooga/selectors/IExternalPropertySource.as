package net.wooga.selectors {

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	import org.as3commons.collections.Set;

	public interface IExternalPropertySource {
		function stringValueForProperty(subject:ISelectorAdapter, name:String):String;

		//TODO (arneschroppe 12/1/12) change return type to Array?
		function collectionValueForProperty(subject:ISelectorAdapter, name:String):Set;
	}
}
