package net.wooga.uiengine.displaylistselector.pseudoclasses {
	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.getAdapterForObject;
	import net.wooga.uiengine.displaylistselector.styleadapter.DisplayObjectStyleAdapter;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class FirstChildTest extends ContextViewBasedTest {

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

			var displayTree:DisplayTree = new DisplayTree();
			displayTree.hasA(contextView).containing
				.a(TestSpriteA).whichWillBeStoredIn(instances)
				.a(TestSpriteB).whichWillBeStoredIn(instances)
				.a(TestSpriteC).whichWillBeStoredIn(instances)
			.end.finish();

			_pseudoClass = new FirstChild();

			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[0])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[1])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[2])), equalTo(false));
		}
	}
}
