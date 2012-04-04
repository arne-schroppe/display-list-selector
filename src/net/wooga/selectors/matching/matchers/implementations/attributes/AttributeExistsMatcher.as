package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class AttributeExistsMatcher  implements IMatcher {
		private var _property:String;
		public function AttributeExistsMatcher(property:String) {
			_property = property;
		}

		public function isMatching(subject:SelectorAdapter):Boolean {
			return _property in subject.getAdaptedElement();
		}
	}
}