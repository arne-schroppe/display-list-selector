package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	import org.flexunit.assertThat;
	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.object.equalTo;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;

	public class AttributeBeginsWithMatcherTest {

		private var _matcher:AttributeBeginsWithMatcher;

		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();

		[Mock]
		public var adapter:SelectorAdapter;

		[Mock]
		public var object:IObjectWithProperty;


		[Before]
		public function setUp():void {
			given(adapter.getAdaptedElement()).willReturn(object);
		}


		[Test]
		public function should_match_equal_values():void {
			given(object.property).willReturn("12");
			_matcher = new AttributeBeginsWithMatcher(null, "property", "12");
			assertThat(_matcher.isMatching(adapter), equalTo(true));
		}


		[Test]
		public function should_match_if_value_begins_with():void {
			given(object.property).willReturn("123456");
			_matcher = new AttributeBeginsWithMatcher(null, "property", "12");
			assertThat(_matcher.isMatching(adapter), equalTo(true));
		}

		[Test]
		public function should_not_match_if_empty_string():void {

			given(object.property).willReturn("123456");
			_matcher = new AttributeBeginsWithMatcher(null, "property", "");
			assertThat(_matcher.isMatching(adapter), equalTo(false));
		}
	}
}
