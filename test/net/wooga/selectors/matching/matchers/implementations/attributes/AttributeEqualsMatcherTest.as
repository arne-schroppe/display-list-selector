package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	import org.flexunit.assertThat;

	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.object.equalTo;

	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;


	public class AttributeEqualsMatcherTest  {

		private var _matcher:AttributeEqualsMatcher;


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
			given(object.property).willReturn("abcde");
			_matcher = new AttributeEqualsMatcher(null, "property", "abcde");
			assertThat(_matcher.isMatching(adapter), equalTo(true));
		}



		[Test]
		public function should_not_match_if_value_is_just_a_substring():void {
			given(object.property).willReturn("abc12defg");
			_matcher = new AttributeEqualsMatcher(null, "property", "12");
			assertThat(_matcher.isMatching(adapter), equalTo(false));
		}



		[Test]
		public function whitespace_in_values_should_be_significant():void {
			given(object.property).willReturn("  abcde  ");
			_matcher = new AttributeEqualsMatcher(null, "property", "abcde");
			assertThat(_matcher.isMatching(adapter), equalTo(false));
		}

	}
}

