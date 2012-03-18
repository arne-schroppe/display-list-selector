package net.wooga.selectors.pseudoclasses {

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.getAdapterForObject;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class NthOfTypeTest extends ContextViewBasedTest {

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
		public function should_match_second_of_type_only():void {

			var instances:Array = [];

			var displayTree:DisplayTree = new DisplayTree();
			displayTree.hasA(contextView).containing
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)

					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.end.finish();

			_pseudoClass = new NthOfType();
			_pseudoClass.setArguments(["2"]);

			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[0])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[1])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[2])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[3])), equalTo(false));

			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[4])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[5])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[6])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[7])), equalTo(false));
		}


		[Test]
		public function should_match_every_first_of_two_items():void {

			var instances:Array = [];

			var displayTree:DisplayTree = new DisplayTree();
			displayTree.hasA(contextView).containing
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)

					.a(TestSpriteC).whichWillBeStoredIn(instances)

					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.end.finish();

			_pseudoClass = new NthOfType();
			_pseudoClass.setArguments(["2n + 1"]);

			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[0])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[1])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[2])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[3])), equalTo(false));

			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[4])), equalTo(true));

			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[5])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[6])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[7])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[8])), equalTo(false));
		}



		[Test]
		public function should_match_even_items():void {

			var instances:Array = [];

			var displayTree:DisplayTree = new DisplayTree();
			displayTree.hasA(contextView).containing
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)

					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.end.finish();

			_pseudoClass = new NthOfType();
			_pseudoClass.setArguments(["even"]);

			/* this might look odd, but index 1, 3 and 5 are the even indices in terms of CSS, where indices are 1-based (asc) */
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[0])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[1])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[2])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[3])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[4])), equalTo(false));


			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[5])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[6])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[7])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[8])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[9])), equalTo(false));
		}


		[Test]
		public function should_match_odd_items():void {

			var instances:Array = [];

			var displayTree:DisplayTree = new DisplayTree();
			displayTree.hasA(contextView).containing
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)

					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.end.finish();

			_pseudoClass = new NthOfType();
			_pseudoClass.setArguments(["odd"]);

			/* this might look weird, but index 0, 2, 4 are the odd indices in terms of CSS, where indices are 1-based (asc) */
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[0])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[1])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[2])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[3])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[4])), equalTo(true));

			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[5])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[6])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[7])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[8])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[9])), equalTo(true));
		}



		[Test]
		public function should_match_first_three_items():void {

			var instances:Array = [];

			var displayTree:DisplayTree = new DisplayTree();
			displayTree.hasA(contextView).containing
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)

					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.end.finish();

			_pseudoClass = new NthOfType();
			_pseudoClass.setArguments(["-n+3"]);

			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[0])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[1])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[2])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[3])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[4])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[5])), equalTo(false));



			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[6])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[7])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[8])), equalTo(true));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[9])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[10])), equalTo(false));
			assertThat(_pseudoClass.isMatching(getAdapterForObject(instances[11])), equalTo(false));

		}

	}
}
