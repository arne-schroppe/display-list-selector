package net.wooga.uiengine.displaylistselector.pseudoclasses {
	import net.arneschroppe.displaytreebuilder.DisplayTreeBuilder;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;

	import org.hamcrest.assertThat;

	import org.hamcrest.object.equalTo;

	public class RootTest extends ContextViewBasedTest {

		private var _pseudoClass:IPseudoClass;

		[Before]
		override public function setUp():void {
			super.setUp();
		}

		[After]
		override public function tearDown():void {
			super.tearDown();
		}


		[Test]
		public function should_match_first_child_only():void {

			var instances:Array = [];

			var displayTree:DisplayTreeBuilder = new DisplayTreeBuilder();
			displayTree.startWith(contextView).begin
				.add(TestSpriteA).andStoreInstanceIn(instances).begin
					.add(TestSpriteB).andStoreInstanceIn(instances)
					.add(TestSpriteC).andStoreInstanceIn(instances)
				.end
			.end;

			_pseudoClass = new Root(contextView);

			assertThat(_pseudoClass.isMatching(contextView), equalTo(true));
			assertThat(_pseudoClass.isMatching(instances[0]), equalTo(false));
			assertThat(_pseudoClass.isMatching(instances[1]), equalTo(false));
			assertThat(_pseudoClass.isMatching(instances[2]), equalTo(false));
		}
	}
}
