package net.wooga.uiengine.displaylistselector.matchers.implementations {
	import net.arneschroppe.displaytreebuilder.DisplayTreeBuilder;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.containsInArrayExactly;
	import net.wooga.utils.flexunit.hamcrestcollection.everyItemInCollection;

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
			var tree:DisplayTreeBuilder = new DisplayTreeBuilder();

			tree.startWith(contextView).begin
					.add(TestSpriteA)
					.add(TestSpriteB).withName("testName")
					.add(TestSpriteC)
					.add(TestSpriteB).withName("testName")
					.add(TestSpriteA).withName("other")
					.add(TestSpriteA)
					.add(TestSpriteC).withName("testName")
					.add(TestSpriteC).withName("some other")
					.add(TestSpriteA).withName("testName")
				.end.finish();

			_matcher = new PropertyFilterEqualsMatcher(new NoCallPropertySource(), "name", "testName");

			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {
				if(_matcher.isMatching(contextView.getChildAt(i))) {
					matchedObjects.push(contextView.getChildAt(i));
				}

			}

			assertThat(matchedObjects, containsInArrayExactly(1, isA(TestSpriteA)));
			assertThat(matchedObjects, containsInArrayExactly(2, isA(TestSpriteB)));
			assertThat(matchedObjects, containsInArrayExactly(1, isA(TestSpriteC)));
			assertThat(matchedObjects.length, equalTo(4));
		}


		[Test]
		public function should_use_external_property_source_for_unknown_properties():void {
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
				.end.finish();

			_matcher = new PropertyFilterEqualsMatcher(new ClassNamePropertySource(), "testProperty", "TestSpriteA");

			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {
				if(_matcher.isMatching(contextView.getChildAt(i))) {
					matchedObjects.push(contextView.getChildAt(i));
				}

			}

			assertThat(matchedObjects, everyItem(isA(TestSpriteA)));
			assertThat(matchedObjects.length, equalTo(4));
		}
	}
}

import flash.display.DisplayObject;
import flash.utils.getQualifiedClassName;

import net.wooga.uiengine.displaylistselector.IExternalPropertySource;

import org.as3commons.collections.Set;


class NoCallPropertySource implements IExternalPropertySource {

	public function stringValueForProperty(subject:DisplayObject, name:String):String {
		throw new Error("Unexpected method called");
	}

	public function collectionValueForProperty(subject:DisplayObject, name:String):Set {
		throw new Error("Unexpected method called");
	}
}


class ClassNamePropertySource implements IExternalPropertySource {

	public function stringValueForProperty(subject:DisplayObject, name:String):String {
		if(name == "testProperty") {
			return getQualifiedClassName(subject).split("::").pop();
		}

		return null;
	}

	public function collectionValueForProperty(subject:DisplayObject, name:String):Set {
		throw new Error("Unexpected method called");
	}
}
