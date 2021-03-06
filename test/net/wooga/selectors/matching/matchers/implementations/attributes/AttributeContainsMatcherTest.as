package net.wooga.selectors.matching.matchers.implementations.attributes {

	import flash.display.DisplayObject;

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.tools.ContextViewBasedTest;
	import net.wooga.fixtures.tools.containsInArrayExactly;
	import net.wooga.fixtures.tools.getAdapterForObject;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;

	public class AttributeContainsMatcherTest extends ContextViewBasedTest {


		private var _matcher:AttributeContainsMatcher;
		
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

			tree.uses(contextView).containing
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

			_matcher = new AttributeContainsMatcher(new TestPropertySource(), "testProperty", "TestSpriteC");

			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {

				if(_matcher.isMatching(getAdapterForObjectAtIndex(i))) {
					matchedObjects = matchedObjects.concat(contextView.getChildAt(i));
				}
			}

			assertThat(matchedObjects, containsInArrayExactly(3, isA(TestSpriteC)));
			assertThat(matchedObjects.length, equalTo(3));
		}


		private function getAdapterForObjectAtIndex(index:int):SelectorAdapter {
			var object:DisplayObject = contextView.getChildAt(index);
			return getAdapterForObject(object);
		}
	}
}

import flash.utils.getQualifiedClassName;

import net.wooga.selectors.ExternalPropertySource;
import net.wooga.selectors.selectoradapter.SelectorAdapter;

class TestPropertySource implements ExternalPropertySource {

	public function stringValueForProperty(subject:SelectorAdapter, name:String):String {
		throw new Error("Unexpected method called");
	}

	public function collectionValueForProperty(subject:SelectorAdapter, name:String):Array {

		if(name == "testProperty") {
			var result:Array = new Array();
			result.push(getQualifiedClassName(subject.getAdaptedElement()).split("::").pop());
			result.push("dummy1");
			result.push("dummy2");
			result.push("dummy3");

			return result;
		}
		else {
			return null;
		}
	}
}

