package net.wooga.uiengine.displaylistselector {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.TestSpriteWithInterface;
	import net.wooga.fixtures.package1.TestSpritePack;
	import net.wooga.fixtures.package2.TestSpritePack;
	import net.wooga.uiengine.displaylistselector.styleadapter.DisplayObjectStyleAdapter;
	import net.wooga.utils.flexunit.hamcrestcollection.containsExactly;
	import net.wooga.utils.flexunit.hamcrestcollection.everyItemInCollection;
	import net.wooga.utils.flexunit.hamcrestcollection.hasItemInCollection;

	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.IIterable;
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasPropertyWithValue;

	public class SelectorTest extends ContextViewBasedTest {


		private var _selectors:AbstractSelectors;
		private var _displayList:DisplayTree;
		private var _propertyDictionary:PropertyDictionary;

		override public function setUp():void {
			super.setUp();
			_propertyDictionary = new PropertyDictionary();
			_displayList = new DisplayTree();

			_selectors = new AbstractSelectors();
			_selectors.initializeWith(contextView, _propertyDictionary, "id", "class");
			_selectors.setDefaultStyleAdapter(DisplayObjectStyleAdapter);
		}


		[Test]
		public function should_match_element_selector():void {

			_displayList.hasA(contextView).containing
				.a(TestSpriteA)
				.a(TestSpriteB)
				.a(TestSpriteC)
			.end.finish();


			var matchedObjects:Set = getMatchedObjectsFor("TestSpriteB");
			assert_should_match_element_selector(matchedObjects);

			//Second call tests cached version
			//matchedObjects = getMatchedObjectsFor("TestSpriteB");
			//assert_should_match_element_selector(matchedObjects);
		}



		private function assert_should_match_element_selector(matchedObjects:Set):void {
			assertContainsObjectOfClass(matchedObjects, TestSpriteB);
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteA);
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteC);
		}


		[Test]
		public function should_match_any_selector():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteC)
				.end.finish();


			var matchedObjects:Set = getMatchedObjectsFor("*");
			assert_should_match_any_selector(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_any_selector(matchedObjects);
		}

		private function assert_should_match_any_selector(matchedObjects:Set):void {
			assertContainsObjectOfClass(matchedObjects, TestSpriteA);
			assertContainsObjectOfClass(matchedObjects, TestSpriteB);
			assertContainsObjectOfClass(matchedObjects, TestSpriteC);
		}


		[Test]
		public function should_match_nested_class():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB).containing
						.a(TestSpriteC)
					.end
					.a(TestSpriteC)
				.end.finish();

			var matchedObjects:Set = getMatchedObjectsFor("TestSpriteB > TestSpriteC");
			assert_should_match_nested_class(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_nested_class(matchedObjects);
		}

		private function assert_should_match_nested_class(matchedObjects:Set):void {
			assertContainsObjectOfClass(matchedObjects, TestSpriteC);
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteA);
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteB);
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_class_with_name():void {

			var expectedName:String = "test1234";

			_displayList.hasA(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB).containing
						.a(TestSpriteC)
					.end
					.a(TestSpriteC).withTheName(expectedName)
				.end.finish();

			var matchedObjects:Set = getMatchedObjectsFor("TestSpriteC[name='" + expectedName + "']");
			assert_should_match_class_with_name(matchedObjects, expectedName);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_class_with_name(matchedObjects, expectedName);

		}

		private function assert_should_match_class_with_name(matchedObjects:Set, expectedName:String):void {
			assertThat(matchedObjects, hasItemInCollection(allOf(isA(TestSpriteC), hasPropertyWithValue("name", expectedName))));
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteA);
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteB);
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_class_with_external_property():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA)
				.end.finish();

			var propertyName:String = "obscureExternalProperty";
			var value:String = "success";

			_propertyDictionary.addItem(propertyName, value);
			var matchedObjects:Set = getMatchedObjectsFor("TestSpriteA[" + propertyName + "='" + value + "']");
			assert_should_match_class_with_external_property(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_class_with_external_property(matchedObjects);

		}

		private function assert_should_match_class_with_external_property(matchedObjects:Set):void {
			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_css_id_selector():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA)
				.end.finish();

			var propertyName:String = "id";
			var value:String = "test";

			_propertyDictionary.addItem(propertyName, value);

			var matchedObjects:Set = getMatchedObjectsFor("TestSpriteA#test");
			assert_should_match_css_id_selector(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_css_id_selector(matchedObjects);

		}

		private function assert_should_match_css_id_selector(matchedObjects:Set):void {
			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_oneof_selector():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteC)
				.end.finish();

			var values:Set = new Set();
			values.add("A");
			values.add("B");
			values.add("expectedValue");
			values.add("C");
			_propertyDictionary.addItem("state", values);

			var matchedObjects:Set = getMatchedObjectsFor("TestSpriteA[state~='expectedValue']");
			assert_should_match_oneof_selector(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_oneof_selector(matchedObjects);

		}

		private function assert_should_match_oneof_selector(matchedObjects:Set):void {
			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_cssclass_selector():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteC)
				.end.finish();

			var values:Set = new Set();
			values.add("A");
			values.add("B");
			values.add("testClass");
			values.add("C");
			_propertyDictionary.addItem("class", values);

			var matchedObjects:Set = getMatchedObjectsFor("TestSpriteA.testClass");
			assert_should_match_cssclass_selector(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_cssclass_selector(matchedObjects);

		}

		private function assert_should_match_cssclass_selector(matchedObjects:Set):void {
			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_different_branches():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB).containing
						.a(TestSpriteC)
					.end
					.a(TestSpriteA).containing
						.a(TestSpriteC)
					.end
				.end.finish();

			var matchedObjects:Set = getMatchedObjectsFor("* > TestSpriteC");
			assert_should_match_different_branches(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_different_branches(matchedObjects);

		}

		private function assert_should_match_different_branches(matchedObjects:Set):void {
			assertThat(matchedObjects, containsExactly(2, isA(TestSpriteC)));
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteA);
			assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteB);
			assertEquals(2, matchedObjects.size);
		}


		[Test]
		public function should_match_descendant_objects():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA).containing
						.a(TestSpriteC).containing
							.a(TestSpriteC)
						.end
					.end
					.a(TestSpriteB).containing
						.a(TestSpriteA).containing
							.a(TestSpriteB).containing
								.a(TestSpriteC)
							.end
						.end
					.end
					.a(TestSpriteC)
				.end.finish();

			var matchedObjects:Set = getMatchedObjectsFor("TestSpriteA TestSpriteC");
			assert_should_match_descendant_objects(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_descendant_objects(matchedObjects);

		}

		private function assert_should_match_descendant_objects(matchedObjects:Set):void {
			assertThat(matchedObjects, containsExactly(3, isA(TestSpriteC)));
			assertEquals(3, matchedObjects.size);
		}



		[Test]
		public function should_match_contrived_descendant_objects():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA).containing
						.a(TestSpriteC).containing
							.a(TestSpriteC).containing
								.a(TestSpriteA).containing
									.a(TestSpriteB).containing
										.a(TestSpriteC)
									.end
								.end
							.end
						.end
					.end
					.a(TestSpriteB).containing
						.a(TestSpriteA).containing
							.a(TestSpriteB).containing
								.a(TestSpriteC)
							.end
						.end
					.end
					.a(TestSpriteC)
				.end.finish();

			var matchedObjects:Set = getMatchedObjectsFor("TestSpriteA TestSpriteC");
			assert_should_match_contrived_descendant_objects(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_contrived_descendant_objects(matchedObjects);

		}

		private function assert_should_match_contrived_descendant_objects(matchedObjects:Set):void {
			assertThat(matchedObjects, containsExactly(4, isA(TestSpriteC)));
			assertEquals(4, matchedObjects.size);
		}



		[Test]
		public function should_match_root_pseudo_class():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA).containing
						.a(TestSpriteC).containing
							.a(TestSpriteC)
						.end
					.end
					.a(TestSpriteB).containing
						.a(TestSpriteA).containing
							.a(TestSpriteB).containing
								.a(TestSpriteC)
							.end
						.end
					.end
					.a(TestSpriteC)
				.end.finish();

			var matchedObjects:Set = getMatchedObjectsFor("*:root");
			assert_should_match_root_pseudo_class(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_root_pseudo_class(matchedObjects);

		}

		private function assert_should_match_root_pseudo_class(matchedObjects:Set):void {
			assertThat(matchedObjects, containsExactly(1, equalTo(contextView)));
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_firstchild_pseudo_class():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteC)
				.end.finish();

			var matchedObjects:Set = getMatchedObjectsFor("*:first-child");
			assert_should_match_firstchild_pseudo_class(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_firstchild_pseudo_class(matchedObjects);

		}

		private function assert_should_match_firstchild_pseudo_class(matchedObjects:Set):void {
			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_lastchild_pseudo_class():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteC)
				.end.finish();

			var matchedObjects:Set = getMatchedObjectsFor("*:root > *:last-child");
			assert_should_match_lastchild_pseudo_class(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_lastchild_pseudo_class(matchedObjects);

		}

		private function assert_should_match_lastchild_pseudo_class(matchedObjects:Set):void {
			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteC)));
			assertEquals(1, matchedObjects.size);
		}


		[Test]
		public function should_match_nthchild_pseudo_class():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteA)
					.a(TestSpriteA)
				.end.finish();


			var matchedObjects:Set = getMatchedObjectsFor("*:nth-child(6)");
			assert_should_match_nthchild_pseudo_class(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_nthchild_pseudo_class(matchedObjects);

		}

		private function assert_should_match_nthchild_pseudo_class(matchedObjects:Set):void {
			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteB)));
			assertThat(matchedObjects.size, equalTo(1));
		}


		[Test]
		public function should_match_nthchild_pseudo_class_with_complex_argument():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteB)
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.end.finish();

			var matchedObjects:Set = getMatchedObjectsFor("*:nth-child(-2n + 5)");
			assert_should_match_nthchild_pseudo_class_with_complex_argument(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_nthchild_pseudo_class_with_complex_argument(matchedObjects);

		}

		private function assert_should_match_nthchild_pseudo_class_with_complex_argument(matchedObjects:Set):void {
			assertThat(matchedObjects, containsExactly(3, isA(TestSpriteB)));
			assertEquals(3, matchedObjects.size);
		}


		[Test]
		public function should_match_nthlastchild_pseudo_class():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteA)
					.a(TestSpriteA)
				.end.finish();


			var matchedObjects:Set = getMatchedObjectsFor("*:nth-last-child(3)");
			assert_should_match_nthlastchild_pseudo_class(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_nthlastchild_pseudo_class(matchedObjects);

		}

		private function assert_should_match_nthlastchild_pseudo_class(matchedObjects:Set):void {
			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteB)));
			assertThat(matchedObjects.size, equalTo(1));
		}


		[Test]
		public function should_match_id_and_attribute_selector():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteC)
				.end.finish();

			var values:Set = new Set();
			values.add("A");
			values.add("B");
			values.add("1234");
			values.add("C");
			_propertyDictionary.addItem("testattrib", values);

			var propertyName:String = "id";
			var value:String = "testName";
			_propertyDictionary.addItem(propertyName, value);

			var matchedObjects:Set = getMatchedObjectsFor(":root > *#testName[testattrib~='1234']");
			assert_should_match_id_and_attribute_selector(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_id_and_attribute_selector(matchedObjects);

		}

		private function assert_should_match_id_and_attribute_selector(matchedObjects:Set):void {
			assertThat(matchedObjects.size, equalTo(1));
			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteC)));
		}


		[Test]
		public function should_match_selectors_without_element_selector():void {
			_displayList.hasA(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteC)
				.end.finish();

			var matchedObjects:Set = getMatchedObjectsFor(":root > :nth-child(2)");
			assert_should_match_selectors_without_element_selector(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_selectors_without_element_selector(matchedObjects);

		}

		private function assert_should_match_selectors_without_element_selector(matchedObjects:Set):void {
			assertThat(matchedObjects.size, equalTo(1));
			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteB)));
		}

		[Test]
		public function should_match_isA_selector():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA)
					.a(MovieClip)
					.a(MovieClip)
					.a(TestSpriteB)
				.end.finish();


			var matchedObjects:Set = getMatchedObjectsFor(":root > ^Sprite");
			assert_should_match_isA_selector(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_isA_selector(matchedObjects);

		}

		private function assert_should_match_isA_selector(matchedObjects:Set):void {
			assertThat(matchedObjects.size, equalTo(4));
			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));
			assertThat(matchedObjects, containsExactly(2, isA(MovieClip)));
			assertThat(matchedObjects, containsExactly(1, isA(TestSpriteB)));
		}



		[Test]
		public function should_match_qualified_class_name():void {
			_displayList.hasA(contextView).containing
					.a(net.wooga.fixtures.package1.TestSpritePack)
					.a(net.wooga.fixtures.package2.TestSpritePack)
					.a(TestSpriteA)
					.a(TestSpriteB)
					.end.finish();

			getMatchedObjectsFor("(fixtures.*.TestSpritePack)");
			var matchedObjects:Set = getMatchedObjectsFor("(fixtures.*.TestSpritePack)");
			assert_should_match_qualified_class_name(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_qualified_class_name(matchedObjects);

		}

		private function assert_should_match_qualified_class_name(matchedObjects:Set):void {
			assertThat(matchedObjects.size, equalTo(2));
			assertThat(matchedObjects, containsExactly(1, isA(net.wooga.fixtures.package1.TestSpritePack)));
			assertThat(matchedObjects, containsExactly(1, isA(net.wooga.fixtures.package2.TestSpritePack)));
		}

		[Test]
		public function should_match_interface():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteWithInterface)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteWithInterface)
					.end.finish();

			var matchedObjects:Set = getMatchedObjectsFor(":root > ^TestInterface");
			assert_should_match_interface(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_match_interface(matchedObjects);

		}

		private function assert_should_match_interface(matchedObjects:Set):void {
			assertThat(matchedObjects.size, equalTo(2));
			assertThat(matchedObjects, containsExactly(2, isA(TestSpriteWithInterface)));
		}





		[Ignore("Test not possible because of API changes")]
		[Test]
		public function isA_selector_should_have_lower_specificity_than_element_selector():void {

			//var isASelector:SelectorImpl = new SelectorImpl("^TestSpriteA", _selectors);
			//var elementSelector:SelectorImpl = new SelectorImpl("TestSpriteA", _selectors);

			//assertThat(isASelector.specificity.isLessThan(elementSelector.specificity), isTrue());

		}


		[Test]
		public function should_have_a_comma_separator_to_select_the_union_of_several_selectors():void {

			_displayList.hasA(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteC)
					.a(TestSpriteC)
					.a(TestSpriteC)
					.a(TestSpriteB)
					.a(TestSpriteB)
					.a(TestSpriteB)
					.a(TestSpriteB)
				.end.finish();


			var matchedObjects:Set = getMatchedObjectsFor("TestSpriteA, TestSpriteB");
			assert_should_have_a_comma_separator_to_select_the_union_of_several_selectors(matchedObjects);

			//matchedObjects = _selector.getMatchedObjects();
			//assert_should_have_a_comma_separator_to_select_the_union_of_several_selectors(matchedObjects);
		}


		private function assert_should_have_a_comma_separator_to_select_the_union_of_several_selectors(matchedObjects:Set):void {
			assertThat(matchedObjects.size, equalTo(6));
			assertThat(matchedObjects, containsExactly(2, isA(TestSpriteA)));
			assertThat(matchedObjects, containsExactly(4, isA(TestSpriteB)));
		}


		[Test]
		public function should_build_match_tree_properly():void {
			_displayList.hasA(contextView).containing
					.a(TestSpriteA).containing
						.a(TestSpriteB).containing
							.times(3).a(TestSpriteC)
						.end
					.end
				.end.finish();


			var matchedObjects:Set = getMatchedObjectsFor("TestSpriteB TestSpriteC:first-child, TestSpriteB > TestSpriteC");

			assertThat(matchedObjects.size, equalTo(3));
			assertThat(matchedObjects, containsExactly(3, isA(TestSpriteC)));
		}


		//[Test]
		//public function should_ignore_ignored_types():void {
		//	_displayList.hasA(contextView).containing
		//			.a(TestSpriteA)
		//			.a(TestSpriteA)
		//			.a(TestSpriteC)
		//			.a(TestSpriteC)
		//			.a(TestSpriteC)
		//			.a(TestSpriteB)
		//			.a(TestSpriteB)
		//			.a(TestSpriteB)
		//			.a(TestSpriteB)
		//			.end.finish();
		//
		//	_selectors.ignoreType(TestSpriteC);
		//	_selector = new Selector(":root > ^Sprite", _selectors);
		//
		//	var matchedObjects:Set = _selector.getMatchedObjects();
		//	assertThat(matchedObjects.size, equalTo(6));
		//	assertThat(matchedObjects, containsExactly(2, isA(TestSpriteA)));
		//	assertThat(matchedObjects, containsExactly(4, isA(TestSpriteB)));
		//
		//}



		private function assertContainsObjectOfClass(objects:IIterable, Type:Class):void {
			assertThat(objects, hasItemInCollection(isA(Type)));
		}


		private function assertDoesNotContainObjectOfClass(objects:IIterable, Type:Class):void {
			assertThat(objects, everyItemInCollection(not(isA(Type))));
		}



		private function getMatchedObjectsFor(selectorString:String):Set {
			_selectors.addSelector(selectorString);
			var result:Set = new Set();

			scanForMatches(contextView, selectorString, result);

			return result;

		}

		private function scanForMatches(object:DisplayObject, selectorString:String, result:Set):void {

			_selectors.createStyleAdapterFor(object);

			trace("+++++++++");
			if(_selectors.getSelectorsMatchingObject(object).has(selectorString)) {
				result.add(object);
			}
			trace("---------");

			var container:DisplayObjectContainer = object as DisplayObjectContainer;
			if(container) {
				for(var i:int = 0; i< container.numChildren; ++i) {
					scanForMatches(container.getChildAt(i), selectorString, result);
				}
			}
		}

	}
}

import flash.utils.Dictionary;

import net.wooga.uiengine.displaylistselector.IExternalPropertySource;
import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

import org.as3commons.collections.Set;

class PropertyDictionary implements IExternalPropertySource {

	private var _values:Dictionary = new Dictionary();

	public function addItem(key:String, value:*):void {
		_values[key] = value;
	}

	public function stringValueForProperty(subject:IStyleAdapter, name:String):String {
		return _values[name];
	}

	public function collectionValueForProperty(subject:IStyleAdapter, name:String):Set {
		return _values[name];
	}
}
