package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.selectors.IExternalPropertySource;
	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class AttributeEqualsMatcher implements IMatcher {
		private var _property:String;
		private var _value:String;
		private var _externalPropertySource:IExternalPropertySource;

		public function AttributeEqualsMatcher(externalPropertySource:IExternalPropertySource, property:String, value:String) {
			_externalPropertySource = externalPropertySource;
			_property = property;
			_value = value;
		}

		public function isMatching(subject:SelectorAdapter):Boolean {
			if (!(_property in subject.getAdaptedElement())) {
				return getExternalProperty(subject);
			} else {
				return getObjectProperty(subject);
			}
		}

		private function getObjectProperty(subject:SelectorAdapter):Boolean {
			//TODO (arneschroppe 22/2/12) don't use adaptedElement directly here
			if (subject.getAdaptedElement()[_property] == _value) {
				return true;
			}

			return false;
		}

		private function getExternalProperty(subject:SelectorAdapter):Boolean {
			var currentValue:String = _externalPropertySource.stringValueForProperty(subject, _property);
			if (currentValue == _value) {
				return true;
			}

			return false;
		}


	}
}
