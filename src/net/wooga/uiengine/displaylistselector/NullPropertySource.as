package net.wooga.uiengine.displaylistselector {

	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	import org.as3commons.collections.Set;

	internal class NullPropertySource implements IExternalPropertySource {

		public function stringValueForProperty(subject:IStyleAdapter, name:String):String {
			return null;
		}

		public function collectionValueForProperty(subject:IStyleAdapter, name:String):Set {
			return null;
		}
	}
}
