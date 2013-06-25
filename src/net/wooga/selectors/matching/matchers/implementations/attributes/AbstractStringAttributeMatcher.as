package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.selectors.IExternalPropertySource;
	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.matching.matchers.implementations.combinators.MatcherFamily;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class AbstractStringAttributeMatcher implements IMatcher {

		private var _property:String;
		private var _externalPropertySource:IExternalPropertySource;
		private var _value:String;


		public function AbstractStringAttributeMatcher(externalPropertySource:IExternalPropertySource, property:String, value:String) {
			_externalPropertySource = externalPropertySource;
			_property = property;
			_value = value;
		}

		public function isMatching(subject:ISelectorAdapter):Boolean {
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

		public function get matcherFamily():MatcherFamily {
			return MatcherFamily.SIMPLE_MATCHER;
		}
	}
}
