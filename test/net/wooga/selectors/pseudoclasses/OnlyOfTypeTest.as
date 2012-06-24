package net.wooga.selectors.pseudoclasses {

	import net.wooga.displaytreebuilder.DisplayTree;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.tools.ContextViewBasedTest;
	import net.wooga.fixtures.tools.getAdapterForObject;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class OnlyOfTypeTest extends ContextViewBasedTest {


		private var _pseudoClass:PseudoClass;


		[Before]
		override public function setUp():void {
			super.setUp();

			_pseudoClass = new OnlyOfType();
		}

		[After]
		override public function tearDown():void {
			super.tearDown();
		}

		[Test]
		public function should_match_if_item_has_no_siblings_of_same_type():void {

			var instances:Array = [];
			var displayTree:DisplayTree = new DisplayTree();
			displayTree.uses(contextView).containing
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteC).whichWillBeStoredIn(instances)
					.end.finish();

			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[0])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[1])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[2])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[3])), equalTo(true));
		}
	}
}
