package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.selectors.IExternalPropertySource;

	public class AttributeBeginsWithMatcher extends AbstractStringAttributeMatcher{

		private var _matchedValueLength:int;
		private var _canSucceed:Boolean;

		public function AttributeBeginsWithMatcher(externalPropertySource:IExternalPropertySource, property:String, value:String) {
			super(externalPropertySource, property, value);

			_matchedValueLength = value.length;
			_canSucceed = (value !== "");
		}


		override protected function isValueMatching(objectValue:String, matchedValue:String):Boolean {
			return _canSucceed && (objectValue.substr(0, _matchedValueLength) == matchedValue);
		}
	}
}
