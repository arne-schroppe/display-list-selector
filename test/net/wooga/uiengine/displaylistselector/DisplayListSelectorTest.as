package net.wooga.uiengine.displaylistselector {

	import net.arneschroppe.displaytreebuilder.DisplayTreeBuilder;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.uiengine.displaylistselector.stuff.DisplayListSelectorMatcher;
	import net.wooga.utils.flexunit.hamcrestcollection.containsExactly;
	import net.wooga.utils.flexunit.hamcrestcollection.everyItemInCollection;
	import net.wooga.utils.flexunit.hamcrestcollection.hasItemInCollection;

	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.IIterator;
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasPropertyWithValue;

	public class DisplayListSelectorTest extends ContextViewBasedTest {

		private var _selector:DisplayListSelectorMatcher;
		private var _displayList:DisplayTreeBuilder;
		private var _propertyDictionary:PropertyDictionary;

		override public function setUp():void {
			super.setUp();
			_propertyDictionary = new PropertyDictionary();
			_selector = new DisplayListSelectorMatcher(contextView, _propertyDictionary, "id", "class");
			_displayList = new DisplayTreeBuilder();
		}


		[Test]
		public function should_match_element_selector():void {

			_displayList.startWith(contextView).begin
				.add(TestSpriteA)
				.add(TestSpriteB)
				.add(TestSpriteC)
			.end;

			var matchedObjects:Set = _selector.getObjectsForSelector("TestSpriteB");

			assertContainsObjectOfClass(matchedObjects, TestSpriteB);
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteA);
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteC);
		}


		[Test]
		public function should_match_any_selector():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteA)
					.add(TestSpriteB)
					.add(TestSpriteC)
				.end;


			var matchedObjects:Set = _selector.getObjectsForSelector("*");

			assertContainsObjectOfClass(matchedObjects, TestSpriteA);
			assertContainsObjectOfClass(matchedObjects, TestSpriteB);
			assertContainsObjectOfClass(matchedObjects, TestSpriteC);
		}


		[Test]
		public function should_match_nested_class():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteA)
					.add(TestSpriteB).begin
						.add(TestSpriteC)
					.end
					.add(TestSpriteC)
				.end;


			var matchedObjects:Set = _selector.getObjectsForSelector("TestSpriteB > TestSpriteC");

			assertContainsObjectOfClass(matchedObjects, TestSpriteC);
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteA);
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteB);
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_class_with_name():void {

			var expectedName:String = "test1234";

			_displayList.startWith(contextView).begin
					.add(TestSpriteA)
					.add(TestSpriteB).begin
						.add(TestSpriteC)
					.end
					.add(TestSpriteC).withName(expectedName)
				.end;


			var matchedObjects:Set = _selector.getObjectsForSelector("TestSpriteC[name='" + expectedName + "']");

			assertThat(matchedObjects, hasItemInCollection(allOf(isA(TestSpriteC), hasPropertyWithValue("name", expectedName))));
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteA);
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteB);
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_class_with_external_property():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteA)
				.end;

			var propertyName:String = "obscureExternalProperty";
			var value:String = "success";

			_propertyDictionary.addItem(propertyName, value);
			var matchedObjects:Set = _selector.getObjectsForSelector("TestSpriteA[" + propertyName + "='" + value + "']");

			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_css_id_selector():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteA)
				.end;

			var propertyName:String = "id";
			var value:String = "test";

			_propertyDictionary.addItem(propertyName, value);
			var matchedObjects:Set = _selector.getObjectsForSelector("TestSpriteA#test");

			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_oneof_selector():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteA)
					.add(TestSpriteB)
					.add(TestSpriteC)
				.end;

			var values:Set = new Set();
			values.add("A");
			values.add("B");
			values.add("expectedValue");
			values.add("C");
			_propertyDictionary.addItem("state", values);
			var matchedObjects:Set = _selector.getObjectsForSelector("TestSpriteA[state~='expectedValue']");


			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));

			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_cssclass_selector():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteA)
					.add(TestSpriteB)
					.add(TestSpriteC)
				.end;

			var values:Set = new Set();
			values.add("A");
			values.add("B");
			values.add("testClass");
			values.add("C");
			_propertyDictionary.addItem("class", values);
			var matchedObjects:Set = _selector.getObjectsForSelector("TestSpriteA.testClass");

			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_different_branches():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteA)
					.add(TestSpriteB).begin
						.add(TestSpriteC)
					.end
					.add(TestSpriteA).begin
						.add(TestSpriteC)
					.end
				.end;


			var matchedObjects:Set = _selector.getObjectsForSelector("* > TestSpriteC");

			assertThat(matchedObjects, containsExactly(2, isA(TestSpriteC)));
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteA);
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteB);
			assertEquals(2, matchedObjects.size);
		}


		[Test]
		public function should_match_descendant_objects():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteA).begin
						.add(TestSpriteC).begin
							.add(TestSpriteC)
						.end
					.end
					.add(TestSpriteB).begin
						.add(TestSpriteA).begin
							.add(TestSpriteB).begin
								.add(TestSpriteC)
							.end
						.end
					.end
					.add(TestSpriteC)
				.end;


			var matchedObjects:Set = _selector.getObjectsForSelector("TestSpriteA TestSpriteC");

			assertThat(matchedObjects, containsExactly(3, isA(TestSpriteC)));
			assertEquals(3, matchedObjects.size);
		}



		[Test]
		public function should_match_contrived_descendant_objects():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteA).begin
						.add(TestSpriteC).begin
							.add(TestSpriteC).begin
								.add(TestSpriteA).begin
									.add(TestSpriteB).begin
										.add(TestSpriteC)
									.end
								.end
							.end
						.end
					.end
					.add(TestSpriteB).begin
						.add(TestSpriteA).begin
							.add(TestSpriteB).begin
								.add(TestSpriteC)
							.end
						.end
					.end
					.add(TestSpriteC)
				.end;


			var matchedObjects:Set = _selector.getObjectsForSelector("TestSpriteA TestSpriteC");

			assertThat(matchedObjects, containsExactly(4, isA(TestSpriteC)));
			assertEquals(4, matchedObjects.size);
		}



		[Test]
		public function should_match_root_pseudo_class():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteA).begin
						.add(TestSpriteC).begin
							.add(TestSpriteC)
						.end
					.end
					.add(TestSpriteB).begin
						.add(TestSpriteA).begin
							.add(TestSpriteB).begin
								.add(TestSpriteC)
							.end
						.end
					.end
					.add(TestSpriteC)
				.end;


			var matchedObjects:Set = _selector.getObjectsForSelector("*:root");

			assertThat(matchedObjects, containsExactly(1, equalTo(contextView)));
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_firstchild_pseudo_class():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteA)
					.add(TestSpriteB)
					.add(TestSpriteC)
				.end;


			var matchedObjects:Set = _selector.getObjectsForSelector("*:root > *:first-child");

			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_lastchild_pseudo_class():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteA)
					.add(TestSpriteB)
					.add(TestSpriteC)
				.end;


			var matchedObjects:Set = _selector.getObjectsForSelector("*:root > *:last-child");

			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteC)));
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_nthchild_pseudo_class():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteA)
					.add(TestSpriteA)
					.add(TestSpriteA)
					.add(TestSpriteA)
					.add(TestSpriteA)
					.add(TestSpriteB)
					.add(TestSpriteA)
					.add(TestSpriteA)
				.end;


			var matchedObjects:Set = _selector.getObjectsForSelector("*:root > *:nth-child(6)");

			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteB)));
			assertThat(matchedObjects.size, equalTo(1));
		}


		[Test]
		public function should_match_nthchild_pseudo_class_with_complex_argument():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteB)
					.add(TestSpriteA)
					.add(TestSpriteB)
					.add(TestSpriteA)
					.add(TestSpriteB)
					.add(TestSpriteA)
					.add(TestSpriteA)
					.add(TestSpriteA)
					.end;


			var matchedObjects:Set = _selector.getObjectsForSelector("*:root > *:nth-child(-2n + 5)");

			assertThat(matchedObjects, containsExactly(3, isA(TestSpriteB)));
			assertEquals(3, matchedObjects.size);
		}


		[Test]
		public function should_match_nthlastchild_pseudo_class():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteA)
					.add(TestSpriteA)
					.add(TestSpriteA)
					.add(TestSpriteA)
					.add(TestSpriteA)
					.add(TestSpriteB)
					.add(TestSpriteA)
					.add(TestSpriteA)
				.end;


			var matchedObjects:Set = _selector.getObjectsForSelector("*:root > *:nth-last-child(3)");

			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteB)));
			assertThat(matchedObjects.size, equalTo(1));
		}


		[Test]
		public function should_match_id_and_attribute_selector():void {

			_displayList.startWith(contextView).begin
					.add(TestSpriteC)
				.end;


			var values:Set = new Set();
			values.add("A");
			values.add("B");
			values.add("1234");
			values.add("C");
			_propertyDictionary.addItem("testattrib", values);

			var propertyName:String = "id";
			var value:String = "testName";
			_propertyDictionary.addItem(propertyName, value);


			var matchedObjects:Set = _selector.getObjectsForSelector("*:root > *#testName[testattrib~='1234']");
			assertThat(matchedObjects.size, equalTo(1));

			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteC)));

		}


		[Test]
		public function should_match_selectors_without_element_selector():void {
			_displayList.startWith(contextView).begin
					.add(TestSpriteA)
					.add(TestSpriteB)
					.add(TestSpriteC)
				.end;

			/*IMPORTANT: We need to add ":root >" in front of the selector under test. Otherwise
			 the contextView (which is :root in this case) is ALSO matched, which might lead to erratic
			 behaviour (since we don't know how many siblings contextView has on the stage) (arneschroppe 23/12/11)
			 */
			var matchedObjects:Set = _selector.getObjectsForSelector(":root > :nth-child(2)");


			assertThat(matchedObjects.size, equalTo(1));
			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteB)));
		}


		private function assertContainsObjectOfClass(objects:IIterable, Type:Class):void {
			assertThat(objects, hasItemInCollection(isA(Type)));
		}


		private function assertDoesNotContainObjectOfClass(objects:IIterable, Type:Class):void {
			assertThat(objects, everyItemInCollection(not(isA(Type))));
		}


	}
}

import flash.display.DisplayObject;
import flash.utils.Dictionary;

import net.wooga.uiengine.displaylistselector.stuff.IExternalPropertySource;
import net.wooga.utils.flexunit.assertcollection.itemasserts.IItemAssert;

import org.as3commons.collections.Set;

class PropertyDictionary implements IExternalPropertySource {

	private var _values:Dictionary = new Dictionary();

	public function addItem(key:String, value:*):void {
		_values[key] = value;
	}

	public function stringValueForProperty(subject:DisplayObject, name:String):String {
		return _values[name];
	}

	public function collectionValueForProperty(subject:DisplayObject, name:String):Set {
		return _values[name];
	}
}

class IsObject implements IItemAssert {

	private var _expectedObject:Object;

	public function IsObject(expectedObject:Object) {
		_expectedObject = expectedObject;
	}

	public function isMatch(subject:Object):Boolean {
		return subject === _expectedObject;
	}
}
