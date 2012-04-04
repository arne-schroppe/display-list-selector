package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.selectors.ExternalPropertySource;

	public class AttributeEqualsMatcher extends AbstractStringAttributeMatcher {


		public function AttributeEqualsMatcher(externalPropertySource:ExternalPropertySource, property:String, value:String) {
			super(externalPropertySource, property, value);
		}


		override protected function isValueMatching(objectValue:String, matcherValue:String):Boolean {
			return objectValue == matcherValue;
		}
	}
}
