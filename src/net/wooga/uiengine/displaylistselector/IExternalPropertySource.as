package net.wooga.uiengine.displaylistselector {
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	import org.as3commons.collections.Set;

	public interface IExternalPropertySource {
		function stringValueForProperty(subject:IStyleAdapter, name:String):String;

		//TODO (arneschroppe 12/1/12) change return type to Array?
		function collectionValueForProperty(subject:IStyleAdapter, name:String):Set;
	}
}
