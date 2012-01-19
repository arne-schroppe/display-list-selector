package net.wooga.uiengine.displaylistselector.pseudoclasses {
	import net.arneschroppe.displaytreebuilder.DisplayTreeBuilder;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class NthChildTest extends ContextViewBasedTest {

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

			var displayTree:DisplayTreeBuilder = new DisplayTreeBuilder();
			displayTree.startWith(contextView).begin
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
				.end.finish();

			_pseudoClass = new NthChild();
			_pseudoClass.setArguments([2]);

			assertThat(_pseudoClass.isMatching(instances[0]), equalTo(false));
			assertThat(_pseudoClass.isMatching(instances[1]), equalTo(true));
			assertThat(_pseudoClass.isMatching(instances[2]), equalTo(false));
			assertThat(_pseudoClass.isMatching(instances[3]), equalTo(false));
		}


		[Test]
		public function should_match_every_second_item():void {

			var instances:Array = [];

			var displayTree:DisplayTreeBuilder = new DisplayTreeBuilder();
			displayTree.startWith(contextView).begin
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
				.end.finish();

			_pseudoClass = new NthChild();
			_pseudoClass.setArguments(["2n + 1"]);

			assertThat(_pseudoClass.isMatching(instances[0]), equalTo(true));
			assertThat(_pseudoClass.isMatching(instances[1]), equalTo(false));
			assertThat(_pseudoClass.isMatching(instances[2]), equalTo(true));
			assertThat(_pseudoClass.isMatching(instances[3]), equalTo(false));
		}



		[Test]
		public function should_match_even_items():void {

			var instances:Array = [];

			var displayTree:DisplayTreeBuilder = new DisplayTreeBuilder();
			displayTree.startWith(contextView).begin
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
				.end.finish();

			_pseudoClass = new NthChild();
			_pseudoClass.setArguments(["even"]);

			/* this might look odd, but index 1, 3 and 5 are the even indices in terms of CSS, where indices are 1-based (asc) */
			assertThat(_pseudoClass.isMatching(instances[0]), equalTo(false));
			assertThat(_pseudoClass.isMatching(instances[1]), equalTo(true));
			assertThat(_pseudoClass.isMatching(instances[2]), equalTo(false));
			assertThat(_pseudoClass.isMatching(instances[3]), equalTo(true));
			assertThat(_pseudoClass.isMatching(instances[4]), equalTo(false));
			assertThat(_pseudoClass.isMatching(instances[5]), equalTo(true));
		}





		[Test]
		public function should_match_odd_items():void {

			var instances:Array = [];

			var displayTree:DisplayTreeBuilder = new DisplayTreeBuilder();
			displayTree.startWith(contextView).begin
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.end.finish();

			_pseudoClass = new NthChild();
			_pseudoClass.setArguments(["odd"]);

			/* this might look odd, but index 0, 2, 4 are the odd indices in terms of CSS, where indices are 1-based (asc) */
			assertThat(_pseudoClass.isMatching(instances[0]), equalTo(true));
			assertThat(_pseudoClass.isMatching(instances[1]), equalTo(false));
			assertThat(_pseudoClass.isMatching(instances[2]), equalTo(true));
			assertThat(_pseudoClass.isMatching(instances[3]), equalTo(false));
			assertThat(_pseudoClass.isMatching(instances[4]), equalTo(true));
			assertThat(_pseudoClass.isMatching(instances[5]), equalTo(false));

		}



		[Test]
		public function should_match_first_three_items():void {

			var instances:Array = [];

			var displayTree:DisplayTreeBuilder = new DisplayTreeBuilder();
			displayTree.startWith(contextView).begin
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.add(TestSpriteA).andStoreInstanceIn(instances)
					.end.finish();

			_pseudoClass = new NthChild();
			_pseudoClass.setArguments(["-n+3"]);

			assertThat(_pseudoClass.isMatching(instances[0]), equalTo(true));
			assertThat(_pseudoClass.isMatching(instances[1]), equalTo(true));
			assertThat(_pseudoClass.isMatching(instances[2]), equalTo(true));
			assertThat(_pseudoClass.isMatching(instances[3]), equalTo(false));
			assertThat(_pseudoClass.isMatching(instances[4]), equalTo(false));
			assertThat(_pseudoClass.isMatching(instances[5]), equalTo(false));

		}
	}
}
