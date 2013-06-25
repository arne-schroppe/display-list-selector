package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	import org.flexunit.assertThat;
	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.object.equalTo;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;

	public class AttributeEndsWithMatcherTest {

		private var _matcher:AttributeEndsWithMatcher;

		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();

		[Mock]
		public var adapter:ISelectorAdapter;

		[Mock]
		public var object:IObjectWithProperty;


		[Before]
		public function setUp():void {
			given(adapter.getAdaptedElement()).willReturn(object);
		}


		[Test]
		public function should_match_equal_values():void {
			given(object.property).willReturn("12");
			_matcher = new AttributeEndsWithMatcher(null, "property", "12");
			assertThat(_matcher.isMatching(adapter), equalTo(true));
		}


		[Test]
		public function should_match_if_objectvalue_ends_with_matchedvalue():void {
			given(object.property).willReturn("123456");
			_matcher = new AttributeEndsWithMatcher(null, "property", "56");
			assertThat(_matcher.isMatching(adapter), equalTo(true));
		}



		[Test]
		public function should_not_match_if_empty_string():void {

			given(object.property).willReturn("123456");
			_matcher = new AttributeEndsWithMatcher(null, "property", "");
			assertThat(_matcher.isMatching(adapter), equalTo(false));
		}
	}
}
