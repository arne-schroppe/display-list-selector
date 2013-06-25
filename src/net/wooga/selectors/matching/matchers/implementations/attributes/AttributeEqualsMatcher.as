package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.selectors.IExternalPropertySource;

	public class AttributeEqualsMatcher extends AbstractStringAttributeMatcher {


		public function AttributeEqualsMatcher(externalPropertySource:IExternalPropertySource, property:String, value:String) {
			super(externalPropertySource, property, value);
		}


		override protected function isValueMatching(objectValue:String, matcherValue:String):Boolean {
			return objectValue == matcherValue;
		}
	}
}
