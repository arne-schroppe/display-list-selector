package net.wooga.selectors.matching.matchers.implementations.attributes {

	import net.wooga.fixtures.tools.ContextViewBasedTest;
	import net.wooga.selectors.ExternalPropertySource;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.any;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;
	import org.mockito.integrations.never;
	import org.mockito.integrations.verify;

	public class AbstractStringAttributeMatcherTest extends ContextViewBasedTest {


		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();


		[Mock]
		public var externalPropertySource:ExternalPropertySource;

		[Mock]
		public var adapter:SelectorAdapter;

		[Mock]
		public var object:IObjectWithProperty;


		private var _matcher:AbstractStringAttributeMatcher;


		[Before]
		override public function setUp():void {
			super.setUp();
		}

		[After]
		override public function tearDown():void {
			super.tearDown();
		}



		[Test]
		public function should_use_existing_properties_directly():void {

			var attributeName:String = "property";

			_matcher = new AbstractStringAttributeMatcher(externalPropertySource, attributeName, "123");

			given(adapter.getAdaptedElement()).willReturn(object);

			_matcher.isMatching(adapter);

			verify(never()).that(externalPropertySource.stringValueForProperty(any(), any()));
			verify().that(object.property);

		}



		[Test]
		public function should_use_external_property_source_for_unknown_properties():void {

			var attributeName:String = "unknownProperty";

			_matcher = new AbstractStringAttributeMatcher(externalPropertySource, attributeName, "123");

			given(adapter.getAdaptedElement()).willReturn(object);

			_matcher.isMatching(adapter);

			verify().that(externalPropertySource.stringValueForProperty(adapter, attributeName));
			verify(never()).that(object.property);
		}


	}
}

