package net.wooga.uiengine.displaylistselector.stuff {
	import flash.display.DisplayObject;

	import org.as3commons.collections.Set;

	internal class NullPropertySource implements IExternalPropertySource {

		public function stringValueForProperty(subject:DisplayObject, name:String):String {
			return null;
		}

		public function collectionValueForProperty(subject:DisplayObject, name:String):Set {
			return null;
		}
	}
}
