package net.wooga.selectors.pseudoclasses {

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.tools.ContextViewBasedTest;
	import net.wooga.fixtures.tools.getAdapterForObject;
	import net.wooga.selectors.pseudoclasses.fixtures.ProgrammableAdapterMap;

	import org.hamcrest.assertThat;

	import org.hamcrest.object.equalTo;

	public class FirstOfTypeTest extends ContextViewBasedTest {


		private var _pseudoClass:PseudoClass;
		private var _adapterSource:ProgrammableAdapterMap;

		[Before]
		override public function setUp():void {
			super.setUp();

			_adapterSource = new ProgrammableAdapterMap();
			_pseudoClass = new FirstOfType(_adapterSource);
		}

		[After]
		override public function tearDown():void {
			super.tearDown();
		}




		[Test]
		public function should_match_first_of_type():void {

			var instances:Array = [];

			var displayTree:DisplayTree = new DisplayTree();
			displayTree.uses(contextView).containing
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteB).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteA).whichWillBeStoredIn(instances)
					.a(TestSpriteC).whichWillBeStoredIn(instances)
					.a(TestSpriteC).whichWillBeStoredIn(instances)
				.end.finish();


			_adapterSource.map[instances[0]] = getAdapterForObject(instances[0])
			_adapterSource.map[instances[1]] = getAdapterForObject(instances[1])
			_adapterSource.map[instances[2]] = getAdapterForObject(instances[2])
			_adapterSource.map[instances[3]] = getAdapterForObject(instances[3])
			_adapterSource.map[instances[4]] = getAdapterForObject(instances[4])
			_adapterSource.map[instances[5]] = getAdapterForObject(instances[5])
			_adapterSource.map[instances[6]] = getAdapterForObject(instances[6])


			assertThat(_pseudoClass.isMatching(_adapterSource.getAdapterForObject(instances[0])), equalTo(true));
			assertThat(_pseudoClass.isMatching(_adapterSource.getAdapterForObject(instances[1])), equalTo(false));
			assertThat(_pseudoClass.isMatching(_adapterSource.getAdapterForObject(instances[2])), equalTo(true));
			assertThat(_pseudoClass.isMatching(_adapterSource.getAdapterForObject(instances[3])), equalTo(false));
			assertThat(_pseudoClass.isMatching(_adapterSource.getAdapterForObject(instances[4])), equalTo(false));
			assertThat(_pseudoClass.isMatching(_adapterSource.getAdapterForObject(instances[5])), equalTo(true));
			assertThat(_pseudoClass.isMatching(_adapterSource.getAdapterForObject(instances[6])), equalTo(false));
		}

	}
}
