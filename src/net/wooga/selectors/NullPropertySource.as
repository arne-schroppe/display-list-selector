package net.wooga.selectors {

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class NullPropertySource implements IExternalPropertySource {

		public function stringValueForProperty(subject:ISelectorAdapter, name:String):String {
			return null;
		}

		public function collectionValueForProperty(subject:ISelectorAdapter, name:String):Array {
			return null;
		}
	}
}
