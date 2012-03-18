package net.wooga.selectors.matching.matchers {

	import flash.display.DisplayObject;

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.selectors.matching.matchers.implementations.PropertyFilterEqualsMatcher;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.containsInArrayExactly;
	import net.wooga.fixtures.getAdapterForObject;

	import org.hamcrest.assertThat;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;

	public class PropertyFilterEqualsMatcherTest extends ContextViewBasedTest {

		private var _matcher:PropertyFilterEqualsMatcher;

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

			tree.hasA(contextView).containing
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

			_matcher = new PropertyFilterEqualsMatcher(new NoCallPropertySource(), "name", "testName");

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


		private function getAdapterForObjectAtIndex(index:int):ISelectorAdapter {
			var object:DisplayObject = contextView.getChildAt(index);
			return getAdapterForObject(object);
		}


		[Test]
		public function should_use_external_property_source_for_unknown_properties():void {
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

			_matcher = new PropertyFilterEqualsMatcher(new ClassNamePropertySource(), "testProperty", "TestSpriteA");

			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {
				if(_matcher.isMatching(getAdapterForObjectAtIndex(i))) {
					matchedObjects.push(contextView.getChildAt(i));
				}
			}

			assertThat(matchedObjects, everyItem(isA(TestSpriteA)));
			assertThat(matchedObjects.length, equalTo(4));
		}
	}
}

import flash.utils.getQualifiedClassName;

import net.wooga.selectors.IExternalPropertySource;
import net.wooga.selectors.selectoradapter.ISelectorAdapter;

import org.as3commons.collections.Set;

class NoCallPropertySource implements IExternalPropertySource {

	public function stringValueForProperty(subject:ISelectorAdapter, name:String):String {
		throw new Error("Unexpected method called");
	}

	public function collectionValueForProperty(subject:ISelectorAdapter, name:String):Set {
		throw new Error("Unexpected method called");
	}
}


class ClassNamePropertySource implements IExternalPropertySource {

	public function stringValueForProperty(subject:ISelectorAdapter, name:String):String {
		if(name == "testProperty") {
			return getQualifiedClassName(subject.getAdaptedElement()).split("::").pop();
		}

		return null;
	}

	public function collectionValueForProperty(subject:ISelectorAdapter, name:String):Set {
		throw new Error("Unexpected method called");
	}
}
