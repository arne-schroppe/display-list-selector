package net.wooga.selectors.pseudoclasses {

	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.tools.ContextViewBasedTest;
	import net.wooga.fixtures.tools.containsInArrayExactly;
	import net.wooga.fixtures.tools.getAdapterForObject;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;

	public class IsATest extends ContextViewBasedTest {

		private var _pseudoClass:IsA;

		[Before]
		override public function setUp():void {
			super.setUp();

			_pseudoClass = new IsA;
		}

		[Test]
		public function should_match_type_itself():void {
			var tree:DisplayTree = new DisplayTree();

			tree.uses(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteC)
			.end.finish();


			_pseudoClass.setArguments(["TestSpriteA"]);


			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {
				if(_pseudoClass.isMatching(getAdapterForObjectAtIndex(i))) {
					matchedObjects.push(contextView.getChildAt(i));
				}
			}

			assertThat(matchedObjects, containsInArrayExactly(1, isA(TestSpriteA)));
			assertThat(matchedObjects.length, equalTo(1));
		}



		[Test]
		public function should_allow_whitespace():void {
			var tree:DisplayTree = new DisplayTree();

			tree.uses(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteC)
					.end.finish();


			_pseudoClass.setArguments(["     TestSpriteA    "]);


			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {
				if(_pseudoClass.isMatching(getAdapterForObjectAtIndex(i))) {
					matchedObjects.push(contextView.getChildAt(i));
				}
			}

			assertThat(matchedObjects, containsInArrayExactly(1, isA(TestSpriteA)));
			assertThat(matchedObjects.length, equalTo(1));
		}



		[Test]
		public function should_select_elements_that_subclass_a_type():void {
			var tree:DisplayTree = new DisplayTree();

			tree.uses(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(InheritedTestSprite)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(InheritedTestSprite)
					.a(InheritedTestSprite)
					.a(TestSpriteA)
					.a(InheritedTestSprite)
				.end.finish();

			_pseudoClass.setArguments([getQualifiedClassName(TestSpriteB)]);

			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {
				if(_pseudoClass.isMatching(getAdapterForObjectAtIndex(i))) {
					matchedObjects.push(contextView.getChildAt(i));
				}
			}

			assertThat(matchedObjects, containsInArrayExactly(4, allOf(isA(InheritedTestSprite), isA(TestSpriteB))));
			assertThat(matchedObjects.length, equalTo(4));
		}


		[Test]
		public function should_select_elements_that_implements_a_type():void {
			var tree:DisplayTree = new DisplayTree();

			tree.uses(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(ImplementingTestSprite)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(ImplementingTestSprite)
					.a(ImplementingTestSprite)
					.a(TestSpriteA)
				.end.finish();

			_pseudoClass.setArguments([getQualifiedClassName(TestInterface)]);

			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {
				if(_pseudoClass.isMatching(getAdapterForObjectAtIndex(i))) {
					matchedObjects.push(contextView.getChildAt(i));
				}

			}

			assertThat(matchedObjects, containsInArrayExactly(3, allOf(isA(TestInterface), isA(ImplementingTestSprite), isA(TestSpriteC))));
			assertThat(matchedObjects.length, equalTo(3));
		}



		private function getAdapterForObjectAtIndex(index:int):ISelectorAdapter {
			var object:DisplayObject = contextView.getChildAt(index);
			return getAdapterForObject(object);
		}
	}
}

import net.wooga.fixtures.TestSpriteB;
import net.wooga.fixtures.TestSpriteC;

interface TestInterface {

}

class ImplementingTestSprite extends TestSpriteC implements TestInterface {

}

class InheritedTestSprite extends TestSpriteB {

}
