package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.selectors.ExternalPropertySource;

	public class AttributeContainsSubstringMatcher extends AbstractStringAttributeMatcher{

		private var _canSucceed:Boolean;

		public function AttributeContainsSubstringMatcher(externalPropertySource:ExternalPropertySource, property:String, value:String) {
			super(externalPropertySource, property, value);
			_canSucceed = (value !== "");
		}


		override protected function isValueMatching(objectValue:String, matchedValue:String):Boolean {
			return _canSucceed && objectValue.indexOf(matchedValue) != -1;
		}
	}
}
