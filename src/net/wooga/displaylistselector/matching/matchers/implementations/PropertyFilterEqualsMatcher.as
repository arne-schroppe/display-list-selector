package net.wooga.displaylistselector.matching.matchers.implementations {
	import net.wooga.displaylistselector.IExternalPropertySource;
	import net.wooga.displaylistselector.matching.matchers.IMatcher;
	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

	public class PropertyFilterEqualsMatcher implements IMatcher {
		private var _property:String;
		private var _value:String;
		private var _externalPropertySource:IExternalPropertySource;

		public function PropertyFilterEqualsMatcher(externalPropertySource:IExternalPropertySource, property:String, value:String) {
			_externalPropertySource = externalPropertySource;
			_property = property;
			_value = value;
		}

		public function isMatching(subject:ISelectorAdapter):Boolean {
			if (!(_property in subject.getAdaptedElement())) {
				return getExternalProperty(subject);
			} else {
				return getObjectProperty(subject);
			}
		}

		private function getObjectProperty(subject:ISelectorAdapter):Boolean {
			//TODO (arneschroppe 22/2/12) don't use adaptedElement directly here
			if (subject.getAdaptedElement()[_property] == _value) {
				return true;
			}

			return false;
		}

		private function getExternalProperty(subject:ISelectorAdapter):Boolean {
			var currentValue:String = _externalPropertySource.stringValueForProperty(subject, _property);
			if (currentValue == _value) {
				return true;
			}

			return false;
		}


	}
}
