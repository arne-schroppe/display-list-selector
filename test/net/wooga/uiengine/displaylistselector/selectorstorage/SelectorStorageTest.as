package net.wooga.uiengine.displaylistselector.selectorstorage {
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.uiengine.displaylistselector.parser.IPseudoClassProvider;
	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.parser.Parser;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.Hover;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;
	import net.wooga.utils.flexunit.hamcrestcollection.containsExactly;

	import org.as3commons.collections.framework.ICollection;
	import org.as3commons.collections.framework.IIterable;
	import org.flexunit.asserts.fail;
	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasPropertyWithValue;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;

	public class SelectorStorageTest implements IPseudoClassProvider {

		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();



		private var _selectorStorage:SelectorStorage;
		
		private var _parser:Parser;

		[Mock]
		public var styleAdapter:IStyleAdapter;

		[Before]
		public function setUp():void {
			_selectorStorage = new SelectorStorage();
			_parser = new Parser(null, this, null);
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

			var possibleMatches:IIterable = _selectorStorage.getPossibleMatchesFor(styleAdapter);

			assertThat(possibleMatches, containsExactly(1, hasPropertyWithValue("originalSelector", sel1)));
			assertThat(possibleMatches, containsExactly(1, hasPropertyWithValue("originalSelector", sel2)));
			assertThat(possibleMatches, containsExactly(1, hasPropertyWithValue("originalSelector", sel5)));
			assertThat((possibleMatches as ICollection).size, equalTo(3));

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
			var possibleMatches:IIterable = _selectorStorage.getPossibleMatchesFor(styleAdapter);

			assertThat(possibleMatches, containsExactly(1, hasPropertyWithValue("originalSelector", sel1)));
			assertThat(possibleMatches, containsExactly(1, hasPropertyWithValue("originalSelector", sel3)));
			assertThat(possibleMatches, containsExactly(1, hasPropertyWithValue("originalSelector", sel5)));
			assertThat((possibleMatches as ICollection).size, equalTo(3));

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
			given(styleAdapter.isHovered()).willReturn(true);
			var possibleMatches:IIterable = _selectorStorage.getPossibleMatchesFor(styleAdapter);

			assertThat(possibleMatches, containsExactly(1, hasPropertyWithValue("originalSelector", sel1)));
			assertThat(possibleMatches, containsExactly(1, hasPropertyWithValue("originalSelector", sel2)));
			assertThat(possibleMatches, containsExactly(1, hasPropertyWithValue("originalSelector", sel5)));
			assertThat(possibleMatches, containsExactly(1, hasPropertyWithValue("originalSelector", sel6)));
			assertThat((possibleMatches as ICollection).size, equalTo(4));
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
			given(styleAdapter.isHovered()).willReturn(false);
			var possibleMatches:IIterable = _selectorStorage.getPossibleMatchesFor(styleAdapter);

			assertThat(possibleMatches, containsExactly(1, hasPropertyWithValue("originalSelector", sel6)));
			assertThat((possibleMatches as ICollection).size, equalTo(1));

		}

		
		[Test]
		public function should_properly_handle_isA_selectors():void {
			//fail("Implement me");
		}
		

		private function addSelectors(selectorsStrings:Array):void {

			for each(var selectorString:String in selectorsStrings) {
				var parsed:Vector.<ParsedSelector> = _parser.parse(selectorString);

				for each(var selector:ParsedSelector in parsed) {
					_selectorStorage.add(selector);
				}

			}

		}

		public function hasPseudoClass(pseudoClassName:String):Boolean {
			return pseudoClassName == "hover";
		}

		public function getPseudoClass(pseudoClassName:String):IPseudoClass {
			if(pseudoClassName == "hover") {
				return new Hover();
			}
			
			return null;
		}
	}
}
