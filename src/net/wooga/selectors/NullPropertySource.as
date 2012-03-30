package net.wooga.selectors {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	internal class NullPropertySource implements IExternalPropertySource {

		public function stringValueForProperty(subject:SelectorAdapter, name:String):String {
			return null;
		}

		public function collectionValueForProperty(subject:SelectorAdapter, name:String):Array {
			return null;
		}
	}
}
