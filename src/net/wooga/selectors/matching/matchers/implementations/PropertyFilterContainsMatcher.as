package net.wooga.selectors.matching.matchers.implementations {

	import net.wooga.selectors.IExternalPropertySource;
	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class PropertyFilterContainsMatcher implements IMatcher {
		private var _property:String;
		private var _value:String;
		private var _externalPropertySource:IExternalPropertySource;

		public function PropertyFilterContainsMatcher(externalPropertySource:IExternalPropertySource, property:String, value:String) {
			_externalPropertySource = externalPropertySource;
			_property = property;
			_value = value;
		}

		public function isMatching(subject:SelectorAdapter):Boolean {
			if (!(_property in subject)) {
				return getExternalProperty(subject);
			} else {
				return getObjectProperty(subject);
			}
		}

		private function getObjectProperty(subject:SelectorAdapter):Boolean {
			var collection:Array = subject[_property] as Array;
			if (collection && collection.indexOf(_value) != -1) {
				return true;
			}

			return false;
		}

		private function getExternalProperty(subject:SelectorAdapter):Boolean {
			var collection:Array = _externalPropertySource.collectionValueForProperty(subject, _property);

			if (collection && collection.indexOf(_value) != -1) {
				return true;
			}

			return false;
		}
	}
}
