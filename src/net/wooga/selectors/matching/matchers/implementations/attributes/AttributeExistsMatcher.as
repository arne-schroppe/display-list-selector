package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.matching.matchers.implementations.combinators.MatcherFamily;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class AttributeExistsMatcher  implements IMatcher {
		private var _property:String;
		public function AttributeExistsMatcher(property:String) {
			_property = property;
		}

		public function isMatching(subject:ISelectorAdapter):Boolean {
			return _property in subject.getAdaptedElement();
		}


		public function get matcherFamily():MatcherFamily {
			return MatcherFamily.SIMPLE_MATCHER;
		}
	}
}
