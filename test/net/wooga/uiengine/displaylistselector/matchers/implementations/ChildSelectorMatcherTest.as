package net.wooga.uiengine.displaylistselector.matchers.implementations {
	import net.arneschroppe.displaytreebuilder.DisplayTreeBuilder;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.containsInArrayExactly;
	import net.wooga.uiengine.displaylistselector.matchers.IMatcher;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;

	public class ChildSelectorMatcherTest extends ContextViewBasedTest {

		private var _matcher:IMatcher;
		private var _displayTree:DisplayTreeBuilder;

		[Before]
		override public function setUp():void {
			super.setUp();
			_matcher = new ChildSelectorMatcher();
			_displayTree = new DisplayTreeBuilder();
		}

		[After]
		override public function tearDown():void {
			super.tearDown();
		}


		[Test]
		public function should_select_direct_descendants():void {
			_displayTree.startWith(contextView).begin
				.add(TestSpriteB).begin
					.add(TestSpriteC).begin
						.times(4).add(TestSpriteA)
					.end
				.end
				.add(TestSpriteA)
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
