package net.wooga.uiengine.displaylistselector {
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	import org.as3commons.collections.Set;

	public interface IExternalPropertySource {
		function stringValueForProperty(subject:ISelectorAdapter, name:String):String;

		//TODO (arneschroppe 12/1/12) change return type to Array?
		function collectionValueForProperty(subject:ISelectorAdapter, name:String):Set;
	}
}
