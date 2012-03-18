package net.wooga.selectors {

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

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
