package net.wooga.selectors.pseudoclasses {

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.tools.ContextViewBasedTest;
	import net.wooga.fixtures.tools.getAdapterForObject;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class LastChildTest extends ContextViewBasedTest {

		private var _pseudoClass:PseudoClass;

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

			var displayTree:DisplayTree = new DisplayTree();
			displayTree.uses(contextView).containing
				.a(TestSpriteA).whichWillBeStoredIn(instances)
				.a(TestSpriteB).whichWillBeStoredIn(instances)
				.a(TestSpriteC).whichWillBeStoredIn(instances)
			.end.finish();

			_pseudoClass = new LastChild();

			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[0])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[1])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[2])), equalTo(true));


		}

		
	}
}
