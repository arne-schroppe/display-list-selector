package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	import org.flexunit.assertThat;
	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.object.equalTo;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;

	public class AttributeExistsMatcherTest  {

		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();

		[Mock]
		public var adapter:SelectorAdapter;

		[Mock]
		public var object:IObjectWithProperty;

		private var _matcher:AttributeExistsMatcher;

		[Before]
		public function setUp():void {
			given(adapter.getAdaptedElement()).willReturn(object);
		}


		[Test]
		public function should_match_when_property_exists():void {
			_matcher = new AttributeExistsMatcher("property");
			assertThat(_matcher.isMatching(adapter), equalTo(true));
		}



		[Test]
		public function should_not_match_when_property_does_not_exist():void {
			_matcher = new AttributeExistsMatcher("unknownProperty$$$");
			assertThat(_matcher.isMatching(adapter), equalTo(false));
		}
	}
}
