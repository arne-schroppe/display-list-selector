package net.wooga.uiengine.displaylistselector {

	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	import org.as3commons.collections.Set;

	internal class NullPropertySource implements IExternalPropertySource {

		public function stringValueForProperty(subject:ISelectorAdapter, name:String):String {
			return null;
		}

		public function collectionValueForProperty(subject:ISelectorAdapter, name:String):Set {
			return null;
		}
	}
}
