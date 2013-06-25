package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.selectors.IExternalPropertySource;
	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.matching.matchers.implementations.combinators.MatcherFamily;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class AttributeContainsMatcher implements IMatcher {
		private var _property:String;
		private var _value:String;
		private var _externalPropertySource:IExternalPropertySource;

		public function AttributeContainsMatcher(externalPropertySource:IExternalPropertySource, property:String, value:String) {
			_externalPropertySource = externalPropertySource;
			_property = property;
			_value = value;
		}

		public function isMatching(subject:ISelectorAdapter):Boolean {
			if (!(_property in subject)) {
				return getExternalProperty(subject);
			} else {
				return getObjectProperty(subject);
			}
		}

		private function getObjectProperty(subject:ISelectorAdapter):Boolean {
			var collection:Array = subject[_property] as Array;
			if (collection && collection.indexOf(_value) != -1) {
				return true;
			}

			return false;
		}

		private function getExternalProperty(subject:ISelectorAdapter):Boolean {
			var collection:Array = _externalPropertySource.collectionValueForProperty(subject, _property);

			if (collection && collection.indexOf(_value) != -1) {
				return true;
			}

			return false;
		}


		public function get matcherFamily():MatcherFamily {
			return MatcherFamily.SIMPLE_MATCHER;
		}
	}
}
