package net.wooga.uiengine.displaylistselector.matchers.implementations {
	import flash.utils.getTimer;

	import net.arneschroppe.displaytreebuilder.DisplayTreeBuilder;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.containsInArrayExactly;
	import net.wooga.fixtures.package1.TestSpritePack;
	import net.wooga.fixtures.package2.TestSpritePack;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.throws;
	import org.hamcrest.number.lessThan;
	import org.hamcrest.object.equalTo;

	public class TypeNameMatcherTest extends ContextViewBasedTest {


		private var _matcher:TypeNameMatcher;


		[Before]
		override public function setUp():void {
			super.setUp();
		}

		[After]
		override public function tearDown():void {
			super.tearDown();
		}



		[Test]
		public function should_select_elements_with_class_name():void {

			var tree:DisplayTreeBuilder = new DisplayTreeBuilder();

			tree.startWith(contextView).begin
				.add(TestSpriteA)
				.add(TestSpriteB)
				.add(TestSpriteC)
				.add(TestSpriteB)
				.add(TestSpriteA)
				.add(TestSpriteA)
				.add(TestSpriteC)
				.add(TestSpriteC)
				.add(TestSpriteA)
			.end

			_matcher = new TypeNameMatcher("TestSpriteB", true);

			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {
				if(_matcher.isMatching(contextView.getChildAt(i))) {
					matchedObjects.push(contextView.getChildAt(i));
				}

			}

			assertThat(matchedObjects, containsInArrayExactly(2, isA(TestSpriteB)));
			assertThat(matchedObjects.length, equalTo(2));
		}


		[Test]
		public function should_select_elements_that_subclass_a_type():void {
			var tree:DisplayTreeBuilder = new DisplayTreeBuilder();

			tree.startWith(contextView).begin
					.add(TestSpriteA)
					.add(TestSpriteA)
					.add(InheritedTestSprite)
					.add(TestSpriteA)
					.add(TestSpriteA)
					.add(InheritedTestSprite)
					.add(InheritedTestSprite)
					.add(TestSpriteA)
					.add(InheritedTestSprite)
					.end

			_matcher = new TypeNameMatcher("TestSpriteB", false);

			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {
				if(_matcher.isMatching(contextView.getChildAt(i))) {
					matchedObjects.push(contextView.getChildAt(i));
				}
			}

			assertThat(matchedObjects, containsInArrayExactly(4, allOf(isA(InheritedTestSprite), isA(TestSpriteB))));
			assertThat(matchedObjects.length, equalTo(4));
		}


		[Test]
		public function should_select_elements_that_implements_a_type():void {
			var tree:DisplayTreeBuilder = new DisplayTreeBuilder();

			tree.startWith(contextView).begin
					.add(TestSpriteA)
					.add(TestSpriteA)
					.add(ImplementingTestSprite)
					.add(TestSpriteA)
					.add(TestSpriteA)
					.add(TestSpriteA)
					.add(ImplementingTestSprite)
					.add(ImplementingTestSprite)
					.add(TestSpriteA)
				.end

			_matcher = new TypeNameMatcher("TestInterface", false);

			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {
				if(_matcher.isMatching(contextView.getChildAt(i))) {
					matchedObjects.push(contextView.getChildAt(i));
				}

			}

			assertThat(matchedObjects, containsInArrayExactly(3, allOf(isA(TestInterface), isA(ImplementingTestSprite), isA(TestSpriteC))));
			assertThat(matchedObjects.length, equalTo(3));
		}


		[Test]
		public function should_match_partly_qualified_class_names():void {
			var tree:DisplayTreeBuilder = new DisplayTreeBuilder();

			var items:Array = [];

			tree.startWith(contextView).begin
					.add(net.wooga.fixtures.package1.TestSpritePack).andStoreInstanceIn(items)
					.add(net.wooga.fixtures.package1.TestSpritePack).andStoreInstanceIn(items)
					.add(net.wooga.fixtures.package1.TestSpritePack).andStoreInstanceIn(items)
					.add(TestSpriteA).andStoreInstanceIn(items)
					.add(TestSpriteA).andStoreInstanceIn(items)
					.add(net.wooga.fixtures.package2.TestSpritePack).andStoreInstanceIn(items)
					.add(net.wooga.fixtures.package2.TestSpritePack).andStoreInstanceIn(items)
					.add(net.wooga.fixtures.package2.TestSpritePack).andStoreInstanceIn(items)
					.add(net.wooga.fixtures.package2.TestSpritePack).andStoreInstanceIn(items)
					.end

			_matcher = new TypeNameMatcher("fixtures.package2.TestSpritePack", true);

			var matchedObjects:Array = [];

			for(var i:int = 0; i < items.length; ++i) {
				if(_matcher.isMatching(items[i])) {
					matchedObjects.push(items[i]);
				}
			}

			assertThat(matchedObjects, containsInArrayExactly(4, isA(net.wooga.fixtures.package2.TestSpritePack)));
			assertThat(matchedObjects.length, equalTo(4));
		}





		[Test]
		public function should_match_wildcard_package_names():void {
			var tree:DisplayTreeBuilder = new DisplayTreeBuilder();

			var items:Array = [];

			tree.startWith(contextView).begin
					.add(net.wooga.fixtures.package1.TestSpritePack).andStoreInstanceIn(items)
					.add(net.wooga.fixtures.package1.TestSpritePack).andStoreInstanceIn(items)
					.add(net.wooga.fixtures.package1.TestSpritePack).andStoreInstanceIn(items)
					.add(TestSpriteA).andStoreInstanceIn(items)
					.add(TestSpriteA).andStoreInstanceIn(items)
					.add(net.wooga.fixtures.package2.TestSpritePack).andStoreInstanceIn(items)
					.add(net.wooga.fixtures.package2.TestSpritePack).andStoreInstanceIn(items)
					.add(net.wooga.fixtures.package2.TestSpritePack).andStoreInstanceIn(items)
					.add(net.wooga.fixtures.package2.TestSpritePack).andStoreInstanceIn(items)
					.end

			_matcher = new TypeNameMatcher("fixtures.*.TestSpritePack", true);

			var matchedObjects:Array = [];

			for(var i:int = 0; i < items.length; ++i) {
				if(_matcher.isMatching(items[i])) {
					matchedObjects.push(items[i]);
				}
			}

			assertThat(matchedObjects, containsInArrayExactly(4, isA(net.wooga.fixtures.package2.TestSpritePack)));
			assertThat(matchedObjects, containsInArrayExactly(3, isA(net.wooga.fixtures.package1.TestSpritePack)));
			assertThat(matchedObjects.length, equalTo(7));
		}


		[Test]
		public function should_throw_exception_for_illegal_class_name():void {

			assertThat(function ():void {
						new TypeNameMatcher("fixtures.[\w]*.TestSpritePack", true);
					}, throws(isA(ArgumentError))
			);
		}

		[Test]
		public function should_throw_exception_for_trailing_dots():void {

			assertThat(function ():void {
						new TypeNameMatcher("fixtures.somepackage.TestSpritePack.", true);
					}, throws(isA(ArgumentError))
			);
		}


		[Test]
		public function should_throw_exception_for_trailing_dots_at_start():void {

			assertThat(function ():void {
						new TypeNameMatcher(".fixtures.somepackage.TestSpritePack", true);
					}, throws(isA(ArgumentError))
			);
		}


		[Test]
		public function should_throw_exception_for_multiple_dots_in_body():void {

			assertThat(function ():void {
						new TypeNameMatcher("fixtures.somepackage..TestSpritePack", true);
					}, throws(isA(ArgumentError))
			);
		}



		[Test]
		public function should_throw_exception_for_multiple_wildcards_in_body():void {

			assertThat(function ():void {
						new TypeNameMatcher("fixtures.**.TestSpritePack", true);
					}, throws(isA(ArgumentError))
			);
		}



		//TODO (arneschroppe 18/1/12) uncomment this test later
		//[Test]
		//public function should_be_reasonably_fast():void {
		//
		//
		//
		//	var tree:DisplayTreeBuilder = new DisplayTreeBuilder();
		//
		//	var items:Array = [];
		//
		//	_matcher = new TypeNameMatcher("fixtures.package1.TestSpritePack", false);
		//
		//	tree.startWith(contextView).begin
		//			.add(net.wooga.fixtures.package1.TestSpritePack).andStoreInstanceIn(items)
		//			.add(net.wooga.fixtures.package1.TestSpritePack).andStoreInstanceIn(items)
		//			.add(net.wooga.fixtures.package1.TestSpritePack).andStoreInstanceIn(items)
		//			.add(TestSpriteA).andStoreInstanceIn(items)
		//			.add(TestSpriteA).andStoreInstanceIn(items)
		//			.add(net.wooga.fixtures.package2.TestSpritePack).andStoreInstanceIn(items)
		//			.add(net.wooga.fixtures.package2.TestSpritePack).andStoreInstanceIn(items)
		//			.add(net.wooga.fixtures.package2.TestSpritePack).andStoreInstanceIn(items)
		//			.add(net.wooga.fixtures.package2.TestSpritePack).andStoreInstanceIn(items)
		//			.end
		//
		//
		//	var startTime:int = getTimer();
		//
		//	for(var i:int = 0; i < 20000; ++i) {
		//		speedTestMethod(items);
		//	}
		//
		//	var endTime:int = getTimer();
		//
		//	var duration:int = endTime - startTime;
		//	trace(duration);
		//	assertThat(duration, lessThan(900));
		//}
		//
		//
		//private function speedTestMethod(items:Array):void {
		//
		//	var matchedObjects:Array = [];
		//
		//	for(var i:int = 0; i < items.length; ++i) {
		//		if(_matcher.isMatching(items[i])) {
		//			matchedObjects.push(items[i]);
		//		}
		//	}
		//
		//}
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
