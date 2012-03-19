package net.wooga.selectors {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	import org.as3commons.collections.Set;

	internal class NullPropertySource implements IExternalPropertySource {

		public function stringValueForProperty(subject:SelectorAdapter, name:String):String {
			return null;
		}

		public function collectionValueForProperty(subject:SelectorAdapter, name:String):Set {
			return null;
		}
	}
}
