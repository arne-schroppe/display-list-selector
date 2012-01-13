package net.wooga.uiengine.displaylistselector.matchers.implementations {


	import net.arneschroppe.displaytreebuilder.DisplayTreeBuilder;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.TestSpriteD;

	import org.flexunit.asserts.assertEquals;

	public class DescendantSelectorMatcherTest extends ContextViewBasedTest {


		private var _matcher:DescendantSelectorMatcher;

		[Before]
		override public function setUp():void {
			super.setUp();
			_matcher = new DescendantSelectorMatcher();

		}


		[After]
		override public function tearDown():void {
			super.tearDown();
		}

		[Test]
		public function should_return_all_descendants():void {

			var tree:DisplayTreeBuilder = new DisplayTreeBuilder();
			tree.startWith(contextView).begin
						.add(TestSpriteA).begin
							.times(3).add(TestSpriteB)
							.add(TestSpriteD)
						.end
						.add(TestSpriteC).begin
							.add(TestSpriteA).begin
								.add(TestSpriteD)
							.end
						.end
					.end;

			var result:Array = _matcher.isMatching(contextView);

			assertItemsOfType(result, TestSpriteA, 2);
			assertItemsOfType(result, TestSpriteB, 3);
			assertItemsOfType(result, TestSpriteC, 1);
			assertItemsOfType(result, TestSpriteD, 2);

			assertEquals(8, result.length);

		}

		private function assertItemsOfType(subject:Array, Type:Class, expectedCount:int):void {
			var resultCount:int = 0;
			for each(var element:* in subject) {
				if (element is Type) {
					++resultCount;
				}
			}

			assertEquals(expectedCount, resultCount);

		}
	}
}


