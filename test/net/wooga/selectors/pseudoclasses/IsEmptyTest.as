package net.wooga.selectors.pseudoclasses {

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.TestSpriteD;
	import net.wooga.fixtures.tools.ContextViewBasedTest;
	import net.wooga.fixtures.tools.getAdapterForObject;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class IsEmptyTest extends ContextViewBasedTest {

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
		public function should_match_empty_element():void {

			var instances:Array = [];

			var displayTree:DisplayTree = new DisplayTree();
			displayTree.uses(contextView).containing
				.a(TestSpriteA).whichWillBeStoredIn(instances).containing
					.a(TestSpriteD)
				.end
				.a(TestSpriteB).whichWillBeStoredIn(instances).containing
				.end
				.a(TestSpriteC).whichWillBeStoredIn(instances).containing
					.a(TestSpriteD)
				.end
			.end.finish();

			_pseudoClass = new IsEmpty();

			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[0])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[1])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[2])), equalTo(false));

			//TODO (arneschroppe 14/3/12) use mocked adapters instead of using getAdapterForObject
		}
	}
}
