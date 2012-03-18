package net.wooga.selectors.matching.matchers {

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.selectors.matching.matchers.implementations.ChildSelectorMatcher;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;

	public class ChildSelectorMatcherTest extends ContextViewBasedTest {

		private var _matcher:IMatcher;
		private var _displayTree:DisplayTree;

		[Before]
		override public function setUp():void {
			super.setUp();
			_matcher = new ChildSelectorMatcher();
			_displayTree = new DisplayTree();
		}

		[After]
		override public function tearDown():void {
			super.tearDown();
		}


		[Test]
		public function should_select_direct_descendants():void {
			_displayTree.hasA(contextView).containing
				.a(TestSpriteB).containing
					.a(TestSpriteC).containing
						.times(4).a(TestSpriteA)
					.end
				.end
				.a(TestSpriteA)
			.end.finish();

			//TODO fix test
//			var matchedObjects:Array = _matcher.isMatching(contextView);
//
//			assertThat(matchedObjects, containsInArrayExactly(1, isA(TestSpriteA)));
//			assertThat(matchedObjects, containsInArrayExactly(1, isA(TestSpriteB)));
//			assertThat(matchedObjects.length, equalTo(2));

		}


	}
}
