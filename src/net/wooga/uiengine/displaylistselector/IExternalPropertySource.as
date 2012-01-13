package net.wooga.uiengine.displaylistselector {
	import flash.display.DisplayObject;

	import org.as3commons.collections.Set;

	public interface IExternalPropertySource {
		function stringValueForProperty(subject:DisplayObject, name:String):String;

		//TODO (arneschroppe 12/1/12) change return type to Array?
		function collectionValueForProperty(subject:DisplayObject, name:String):Set;
	}
}
