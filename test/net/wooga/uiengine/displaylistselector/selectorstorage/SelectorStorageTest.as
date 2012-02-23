package net.wooga.uiengine.displaylistselector.selectorstorage {
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.uiengine.displaylistselector.parser.Parser;
	import net.wooga.uiengine.displaylistselector.parser.ParserResult;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;
	import net.wooga.utils.flexunit.hamcrestcollection.containsExactly;

	import org.as3commons.collections.framework.ICollection;
	import org.as3commons.collections.framework.IIterable;
	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;

	public class SelectorStorageTest {

		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();



		private var _selectorStorage:SelectorStorage;
		
		private var _parser:Parser;

		[Mock]
		public var styleAdapter:IStyleAdapter;

		[Before]
		public function setUp():void {
			_selectorStorage = new SelectorStorage();
			_parser = new Parser(null, null, null);
		}


		[Test]
		public function should_preselect_selectors_for_specific_type():void {
			
			var sel1:String = "(net.wooga.fixtures.TestSpriteA)";
			var sel2:String = "(net.wooga.fixtures.TestSpriteB) > (net.wooga.fixtures.TestSpriteA)";
			var sel3:String = "(net.wooga.fixtures.TestSpriteA) > (net.wooga.fixtures.TestSpriteB)";
			var sel4:String = "* > (net.wooga.fixtures.TestSpriteC)";

			addSelectors([sel1, sel2, sel3, sel4]);


			given(styleAdapter.getAdaptedElement()).willReturn(new TestSpriteA());

			var possibleMatches:IIterable = _selectorStorage.getPossibleMatchesFor(styleAdapter);

			assertThat(possibleMatches, containsExactly(1, equalTo(sel1)));
			assertThat(possibleMatches, containsExactly(1, equalTo(sel2)));
			assertThat((possibleMatches as ICollection).size, equalTo(2));

		}



		[Test]
		public function should_preselect_selectors_for_specific_id():void {

			var id:String = "testId";
			var sel1:String = "#testId";
			var sel2:String = "(net.wooga.fixtures.TestSpriteB) > #otherId";
			var sel3:String = "(net.wooga.fixtures.TestSpriteA) > #testId";
			var sel4:String = "* > #otherId";

			addSelectors([sel1, sel2, sel3, sel4]);

			given(styleAdapter.getAdaptedElement()).willReturn(new TestSpriteA());
			given(styleAdapter.getId()).willReturn(id);
			var possibleMatches:IIterable = _selectorStorage.getPossibleMatchesFor(styleAdapter);

			assertThat(possibleMatches, containsExactly(1, equalTo(sel1)));
			assertThat(possibleMatches, containsExactly(1, equalTo(sel3)));
			assertThat((possibleMatches as ICollection).size, equalTo(2));

		}


		private function addSelectors(selectorsStrings:Array):void {

			for each(var selectorString:String in selectorsStrings) {
				var parsed:ParserResult = _parser.parse(selectorString);
				_selectorStorage.add(selectorString, parsed);
			}

		}
	}
}
