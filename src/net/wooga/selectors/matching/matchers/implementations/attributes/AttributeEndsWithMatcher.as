package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.selectors.IExternalPropertySource;

	public class AttributeEndsWithMatcher extends AbstractStringAttributeMatcher{

		private var _matchedValueLength:int;
		private var _canSucceed:Boolean;

		public function AttributeEndsWithMatcher(externalPropertySource:IExternalPropertySource, property:String, value:String) {
			super(externalPropertySource, property, value);

			_matchedValueLength = value.length;
			_canSucceed = (value !== "");
		}


		override protected function isValueMatching(objectValue:String, matchedValue:String):Boolean {
			return _canSucceed && objectValue.substring(objectValue.length - _matchedValueLength) == matchedValue;
		}
	}
}
