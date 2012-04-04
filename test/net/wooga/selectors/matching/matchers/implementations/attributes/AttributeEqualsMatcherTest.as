package net.wooga.selectors.matching.matchers.implementations.attributes {

	import flash.display.DisplayObject;

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.tools.ContextViewBasedTest;
	import net.wooga.fixtures.tools.containsInArrayExactly;
	import net.wooga.fixtures.tools.getAdapterForObject;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeEqualsMatcher;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	import org.hamcrest.assertThat;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;

	public class AttributeEqualsMatcherTest extends ContextViewBasedTest {

		private var _matcher:AttributeEqualsMatcher;

		[Before]
		override public function setUp():void {
			super.setUp();
		}

		[After]
		override public function tearDown():void {
			super.tearDown();
		}

		[Test]
		public function should_use_existing_properties_directly():void {
			var tree:DisplayTree = new DisplayTree();

			tree.uses(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB).withTheName("testName")
					.a(TestSpriteC)
					.a(TestSpriteB).withTheName("testName")
					.a(TestSpriteA).withTheName("other")
					.a(TestSpriteA)
					.a(TestSpriteC).withTheName("testName")
					.a(TestSpriteC).withTheName("some other")
					.a(TestSpriteA).withTheName("testName")
				.end.finish();

			_matcher = new AttributeEqualsMatcher(new NoCallPropertySource(), "name", "testName");

			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {
				if(_matcher.isMatching(getAdapterForObjectAtIndex(i))) {
					matchedObjects.push(contextView.getChildAt(i));
				}
			}

			assertThat(matchedObjects, containsInArrayExactly(1, isA(TestSpriteA)));
			assertThat(matchedObjects, containsInArrayExactly(2, isA(TestSpriteB)));
			assertThat(matchedObjects, containsInArrayExactly(1, isA(TestSpriteC)));
			assertThat(matchedObjects.length, equalTo(4));
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

class NoCallPropertySource implements ExternalPropertySource {

	public function stringValueForProperty(subject:SelectorAdapter, name:String):String {
		throw new Error("Unexpected method called");
	}

	public function collectionValueForProperty(subject:SelectorAdapter, name:String):Array {
		throw new Error("Unexpected method called");
	}
}


class ClassNamePropertySource implements ExternalPropertySource {

	public function stringValueForProperty(subject:SelectorAdapter, name:String):String {
		if(name == "testProperty") {
			return getQualifiedClassName(subject.getAdaptedElement()).split("::").pop();
		}

		return null;
	}

	public function collectionValueForProperty(subject:SelectorAdapter, name:String):Array {
		throw new Error("Unexpected method called");
	}
}
