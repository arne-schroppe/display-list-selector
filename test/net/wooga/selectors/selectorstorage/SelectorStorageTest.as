package net.wooga.selectors.selectorstorage {

	import net.wooga.fixtures.SubClassOfTestSpriteA;
	import net.wooga.fixtures.SubSubClassOfTestSpriteA;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.matcher.containsExactlyInArray;
	import net.wooga.selectors.parser.Parser;
	import net.wooga.selectors.parser.PseudoClassProvider;
	import net.wooga.selectors.pseudoclasses.PseudoClass;
	import net.wooga.selectors.pseudoclasses.SettablePseudoClass;
	import net.wooga.selectors.pseudoclasses.names.PseudoClassName;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;

	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasPropertyWithValue;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;

	public class SelectorStorageTest implements PseudoClassProvider {

		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();



		private var _selectorStorage:SelectorTree;
		
		private var _parser:Parser;

		private static const ORIGINAL_SELECTOR_PROPERTY:String = "originalSelectorString";

		[Mock]
		public var styleAdapter:SelectorAdapter;

		[Before]
		public function setUp():void {
			_selectorStorage = new SelectorTree();
			_parser = new Parser(null, this);
		}


		[Test]
		public function should_preselect_selectors_for_specific_type():void {
			
			var sel1:String = "(net.wooga.fixtures.TestSpriteA)";
			var sel2:String = "(net.wooga.fixtures.TestSpriteB) > (net.wooga.fixtures.TestSpriteA)";
			var sel3:String = "(net.wooga.fixtures.TestSpriteA) > (net.wooga.fixtures.TestSpriteB)";
			var sel4:String = "* > (net.wooga.fixtures.TestSpriteC)";
			var sel5:String = "*";

			addSelectors([sel1, sel2, sel3, sel4, sel5]);

			given(styleAdapter.getAdaptedElement()).willReturn(new TestSpriteA());

			var possibleMatches:Array = _selectorStorage.getPossibleMatchesFor(styleAdapter);

			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel1)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel2)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel5)));
			assertThat(possibleMatches.length, equalTo(3));

		}




		[Test]
		public function should_preselect_selectors_for_unqualified_type():void {

			var sel1:String = "TestSpriteA";
			var sel2:String = "TestSpriteB > TestSpriteA";
			var sel3:String = "TestSpriteA > TestSpriteB";
			var sel4:String = "* > TestSpriteC";
			var sel5:String = "*";

			addSelectors([sel1, sel2, sel3, sel4, sel5]);

			given(styleAdapter.getAdaptedElement()).willReturn(new TestSpriteA());

			var possibleMatches:Array = _selectorStorage.getPossibleMatchesFor(styleAdapter);

			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel1)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel2)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel5)));
			assertThat(possibleMatches.length, equalTo(3));

		}


		[Test]
		public function should_preselect_selectors_for_specific_id():void {

			var id:String = "testId";

			var sel1:String = "#testId";
			var sel2:String = "(net.wooga.fixtures.TestSpriteB) > #otherId";
			var sel3:String = "(net.wooga.fixtures.TestSpriteA) > #testId";
			var sel4:String = "* > #otherId";
			var sel5:String = "(net.wooga.fixtures.TestSpriteA)";

			addSelectors([sel1, sel2, sel3, sel4, sel5]);

			given(styleAdapter.getAdaptedElement()).willReturn(new TestSpriteA());
			given(styleAdapter.getId()).willReturn(id);
			var possibleMatches:Array = _selectorStorage.getPossibleMatchesFor(styleAdapter);

			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel1)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel3)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel5)));
			assertThat(possibleMatches.length, equalTo(3));

		}



		[Test]
		public function should_preselect_selectors_for_hover_state():void {

			var id:String = "testId";

			var sel1:String = "(net.wooga.fixtures.TestSpriteA):hover";
			var sel2:String = "#testId:hover";
			var sel3:String = "(net.wooga.fixtures.TestSpriteB):hover";
			var sel4:String = "#otherId:hover";
			var sel5:String = "*:hover";
			var sel6:String = "(net.wooga.fixtures.TestSpriteA)";

			addSelectors([sel1, sel2, sel3, sel4, sel5, sel6]);

			given(styleAdapter.getAdaptedElement()).willReturn(new TestSpriteA());
			given(styleAdapter.getId()).willReturn(id);
			given(styleAdapter.hasPseudoClass(PseudoClassName.hover)).willReturn(true);
			var possibleMatches:Array = _selectorStorage.getPossibleMatchesFor(styleAdapter);

			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel1)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel2)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel5)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel6)));
			assertThat(possibleMatches.length, equalTo(4));
		}


		[Test]
		public function should_not_preselect_hover_states_if_element_is_not_hovered():void {

			var id:String = "testId";

			var sel1:String = "(net.wooga.fixtures.TestSpriteA):hover";
			var sel2:String = "#testId:hover";
			var sel3:String = "(net.wooga.fixtures.TestSpriteB):hover";
			var sel4:String = "#otherId:hover";
			var sel5:String = "*:hover";
			var sel6:String = "(net.wooga.fixtures.TestSpriteA)";

			addSelectors([sel1, sel2, sel3, sel4, sel5, sel6]);

			given(styleAdapter.getAdaptedElement()).willReturn(new TestSpriteA());
			given(styleAdapter.getId()).willReturn(id);
			given(styleAdapter.hasPseudoClass(PseudoClassName.hover)).willReturn(false);
			var possibleMatches:Array = _selectorStorage.getPossibleMatchesFor(styleAdapter);

			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel6)));
			assertThat(possibleMatches.length, equalTo(1));

		}


		//TODO (arneschroppe 14/3/12) test this with unqualified class name
		//TODO (arneschroppe 14/3/12) test this with intermediate classes (SubSubClassOfTestSpriteA)
		[Test]
		public function should_properly_handle_isA_selectors():void {

			var sel1:String = "^(net.wooga.fixtures.TestSpriteA)";
			var sel2:String = "(net.wooga.fixtures.TestSpriteB) > ^(net.wooga.fixtures.TestSpriteA)";
			var sel3:String = "(net.wooga.fixtures.TestSpriteA) > ^(net.wooga.fixtures.TestSpriteB)";
			var sel4:String = "* > ^(net.wooga.fixtures.TestSpriteC)";
			var sel5:String = "^(net.wooga.fixtures.SubClassOfTestSpriteA)";
			var sel6:String = "(net.wooga.fixtures.SubClassOfTestSpriteA)";

			addSelectors([sel1, sel2, sel3, sel4, sel5, sel6]);

			given(styleAdapter.getAdaptedElement()).willReturn(new SubClassOfTestSpriteA());

			var possibleMatches:Array = _selectorStorage.getPossibleMatchesFor(styleAdapter);

			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel1)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel2)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel5)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel6)));
			assertThat(possibleMatches.length, equalTo(4));
		}



		[Test]
		public function should_properly_handle_isA_selectors_with_unqualified_classnames():void {

			var sel1:String = "^TestSpriteA";
			var sel2:String = "(net.wooga.fixtures.TestSpriteB) > ^TestSpriteA";
			var sel3:String = "(net.wooga.fixtures.TestSpriteA) > ^TestSpriteB";
			var sel4:String = "* > ^TestSpriteC";
			var sel5:String = "^SubClassOfTestSpriteA";
			var sel6:String = "SubClassOfTestSpriteA";

			addSelectors([sel1, sel2, sel3, sel4, sel5, sel6]);

			given(styleAdapter.getAdaptedElement()).willReturn(new SubClassOfTestSpriteA());

			var possibleMatches:Array = _selectorStorage.getPossibleMatchesFor(styleAdapter);

			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel1)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel2)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel5)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel6)));
			assertThat(possibleMatches.length, equalTo(4));
		}



		[Test]
		public function should_properly_handle_isA_selectors_with_intermediate_subclasses():void {

			var sel1:String = "^TestSpriteA";
			var sel2:String = "(net.wooga.fixtures.TestSpriteB) > ^SubClassOfTestSpriteA";
			var sel3:String = "(net.wooga.fixtures.TestSpriteA) > ^TestSpriteB";
			var sel4:String = "* > ^TestSpriteC";
			var sel5:String = "^SubClassOfTestSpriteA";
			var sel6:String = "SubClassOfTestSpriteA";

			addSelectors([sel1, sel2, sel3, sel4, sel5, sel6]);

			given(styleAdapter.getAdaptedElement()).willReturn(new SubSubClassOfTestSpriteA());

			var possibleMatches:Array = _selectorStorage.getPossibleMatchesFor(styleAdapter);

			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel1)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel2)));
			assertThat(possibleMatches, containsExactlyInArray(1, hasPropertyWithValue(ORIGINAL_SELECTOR_PROPERTY, sel5)));
			assertThat(possibleMatches.length, equalTo(3));
		}


		private function addSelectors(selectorsStrings:Array):void {

			for each(var selectorString:String in selectorsStrings) {
				var parsed:Vector.<SelectorImpl> = _parser.parse(selectorString);

				for each(var selector:SelectorImpl in parsed) {
					_selectorStorage.add(selector);
				}
			}
		}

		public function hasPseudoClass(pseudoClassName:String):Boolean {
			return pseudoClassName == "hover";
		}

		public function getPseudoClass(pseudoClassName:String):PseudoClass {
			if(pseudoClassName == "hover") {
				return new SettablePseudoClass(PseudoClassName.hover);
			}
			
			return null;
		}
	}
}
