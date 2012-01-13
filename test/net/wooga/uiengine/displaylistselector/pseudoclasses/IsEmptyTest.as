package net.wooga.uiengine.displaylistselector.pseudoclasses {
	import net.arneschroppe.displaytreebuilder.DisplayTreeBuilder;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.TestSpriteD;

	import org.hamcrest.assertThat;

	import org.hamcrest.object.equalTo;

	public class IsEmptyTest extends ContextViewBasedTest {

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
		public function should_match_empty_element():void {

			var instances:Array = [];

			var displayTree:DisplayTreeBuilder = new DisplayTreeBuilder();
			displayTree.startWith(contextView).begin
				.add(TestSpriteA).andStoreInstanceIn(instances).begin
					.add(TestSpriteD)
				.end
				.add(TestSpriteB).andStoreInstanceIn(instances).begin
				.end
				.add(TestSpriteC).andStoreInstanceIn(instances).begin
					.add(TestSpriteD)
				.end
			.end;

			_pseudoClass = new IsEmpty();

			assertThat(_pseudoClass.isMatching(instances[0]), equalTo(false));
			assertThat(_pseudoClass.isMatching(instances[1]), equalTo(true));
			assertThat(_pseudoClass.isMatching(instances[2]), equalTo(false));


		}


	}
}
