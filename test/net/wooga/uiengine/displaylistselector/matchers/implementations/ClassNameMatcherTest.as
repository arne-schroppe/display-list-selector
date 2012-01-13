package net.wooga.uiengine.displaylistselector.matchers.implementations {
	import net.arneschroppe.displaytreebuilder.DisplayTreeBuilder;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.containsInArrayExactly;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;

	public class ClassNameMatcherTest extends ContextViewBasedTest {


		private var _matcher:ClassNameMatcher;


		[Before]
		override public function setUp():void {
			super.setUp();
		}

		[After]
		override public function tearDown():void {
			super.tearDown();
		}



		[Test]
		public function should_select_elements_with_class_name():void {

			var tree:DisplayTreeBuilder = new DisplayTreeBuilder();

			tree.startWith(contextView).begin
				.add(TestSpriteA)
				.add(TestSpriteB)
				.add(TestSpriteC)
				.add(TestSpriteB)
				.add(TestSpriteA)
				.add(TestSpriteA)
				.add(TestSpriteC)
				.add(TestSpriteC)
				.add(TestSpriteA)
			.end

			_matcher = new ClassNameMatcher("TestSpriteB");

			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {
				if(_matcher.isMatching(contextView.getChildAt(i))) {
					matchedObjects.push(contextView.getChildAt(i));
				}

			}


			assertThat(matchedObjects, containsInArrayExactly(2, isA(TestSpriteB)));
			assertThat(matchedObjects.length, equalTo(2));


		}

	}
}
