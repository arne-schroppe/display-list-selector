package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.selectors.ExternalPropertySource;
	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;


	public class AbstractStringAttributeMatcher implements Matcher {

		private var _property:String;
		private var _externalPropertySource:ExternalPropertySource;
		private var _value:String;


		public function AbstractStringAttributeMatcher(externalPropertySource:ExternalPropertySource, property:String, value:String) {
			_externalPropertySource = externalPropertySource;
			_property = property;
			_value = value;
		}

		public function isMatching(subject:SelectorAdapter):Boolean {
			var objectValue:String;
			var adapted:Object = subject.getAdaptedElement();
			if (_property in adapted) {
				objectValue = adapted[_property];
			}
			else {
				objectValue = _externalPropertySource.stringValueForProperty(subject, _property);
			}

			return isValueMatching(objectValue, _value);
		}

		protected function isValueMatching(objectValue:String, matchedValue:String):Boolean {
			return false;
		}
	}
}
