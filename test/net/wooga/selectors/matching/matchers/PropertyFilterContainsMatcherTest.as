package net.wooga.selectors.matching.matchers {

	import flash.display.DisplayObject;

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.selectors.matching.matchers.implementations.PropertyFilterContainsMatcher;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.containsInArrayExactly;
	import net.wooga.fixtures.getAdapterForObject;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;

	public class PropertyFilterContainsMatcherTest extends ContextViewBasedTest {


		private var _matcher:PropertyFilterContainsMatcher;
		
		[Before]
		override public function setUp():void {
			super.setUp();
		}

		[After]
		override public function tearDown():void {
			super.tearDown();
		}



		[Test]
		public function should_filter_elements_that_contain_property():void {
			var tree:DisplayTree = new DisplayTree();

			tree.hasA(contextView).containing
				.a(TestSpriteA)
				.a(TestSpriteB)
				.a(TestSpriteC)
				.a(TestSpriteB)
				.a(TestSpriteA)
				.a(TestSpriteA)
				.a(TestSpriteC)
				.a(TestSpriteC)
				.a(TestSpriteA)
			.end.finish();

			_matcher = new PropertyFilterContainsMatcher(new TestPropertySource(), "testProperty", "TestSpriteC");

			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {

				if(_matcher.isMatching(getAdapterForObjectAtIndex(i))) {
					matchedObjects = matchedObjects.concat(contextView.getChildAt(i));
				}
			}

			assertThat(matchedObjects, containsInArrayExactly(3, isA(TestSpriteC)));
			assertThat(matchedObjects.length, equalTo(3));
		}


		private function getAdapterForObjectAtIndex(index:int):ISelectorAdapter {
			var object:DisplayObject = contextView.getChildAt(index);
			return getAdapterForObject(object);
		}
	}
}

import flash.utils.getQualifiedClassName;

import net.wooga.selectors.IExternalPropertySource;
import net.wooga.selectors.selectoradapter.ISelectorAdapter;

import org.as3commons.collections.Set;

class TestPropertySource implements IExternalPropertySource {

	public function stringValueForProperty(subject:ISelectorAdapter, name:String):String {
		throw new Error("Unexpected method called");
	}

	public function collectionValueForProperty(subject:ISelectorAdapter, name:String):Set {

		if(name == "testProperty") {
			var result:Set = new Set();
			result.add(getQualifiedClassName(subject.getAdaptedElement()).split("::").pop());
			result.add("dummy1");
			result.add("dummy2");
			result.add("dummy3");

			return result;
		}
		else {
			return null;
		}
	}
}

