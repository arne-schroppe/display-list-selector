package net.wooga.selectors.pseudoclasses {

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.tools.ContextViewBasedTest;
	import net.wooga.fixtures.tools.getAdapterForObject;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class OnlyChildTest extends ContextViewBasedTest {


		private var _pseudoClass:PseudoClass;


		[Before]
		override public function setUp():void {
			super.setUp();

			_pseudoClass = new OnlyChild();
		}

		[After]
		override public function tearDown():void {
			super.tearDown();
		}


		[Test]
		public function should_match_if_item_has_no_siblings():void {

			var instances:Array = [];
			var displayTree:DisplayTree = new DisplayTree();
			displayTree.uses(contextView).containing
					.a(TestSpriteA).whichWillBeStoredIn(instances)
				.end.finish();

			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[0])), equalTo(true));
		}



		[Test]
		public function should_not_match_if_item_has_siblings():void {

			var instances:Array = [];
			var displayTree:DisplayTree = new DisplayTree();
			displayTree.uses(contextView).containing
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
				.end.finish();

			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[0])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[1])), equalTo(false));
		}
	}
}
