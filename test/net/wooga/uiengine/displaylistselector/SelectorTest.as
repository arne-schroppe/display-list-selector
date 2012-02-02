package net.wooga.uiengine.displaylistselector {

	import flash.display.MovieClip;
	import flash.display.Sprite;

	import net.arneschroppe.displaytreebuilder.DisplayTree;

	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.TestSpriteWithInterface;
	import net.wooga.fixtures.package1.TestSpritePack;
	import net.wooga.fixtures.package2.TestSpritePack;
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
	import org.hamcrest.object.isTrue;

	public class SelectorTest extends ContextViewBasedTest {


		private var _selectorContext:SelectorContext;
		private var _selector:Selector;
		private var _displayList:DisplayTree;
		private var _propertyDictionary:PropertyDictionary;

		override public function setUp():void {
			super.setUp();
			_propertyDictionary = new PropertyDictionary();
			_displayList = new DisplayTree();

			_selectorContext = new SelectorContext();
			_selectorContext.initializeWith(contextView, _propertyDictionary, "id", "class");
		}


		[Test]
		public function should_match_element_selector():void {

			_displayList.hasA(contextView).containing
				.a(TestSpriteA)
				.a(TestSpriteB)
				.a(TestSpriteC)
			.end.finish();

			_selector = new Selector("TestSpriteB", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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


			_selector = new Selector("*", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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

			_selector = new Selector("TestSpriteB > TestSpriteC", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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

			_selector = new Selector("TestSpriteC[name='" + expectedName + "']", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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

			_propertyDictionary.aItem(propertyName, value);
			_selector = new Selector("TestSpriteA[" + propertyName + "='" + value + "']", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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

			_propertyDictionary.aItem(propertyName, value);

			_selector = new Selector("TestSpriteA#test", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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
			_propertyDictionary.aItem("state", values);

			_selector = new Selector("TestSpriteA[state~='expectedValue']", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();


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
			_propertyDictionary.aItem("class", values);

			_selector = new Selector("TestSpriteA.testClass", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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

			_selector = new Selector("* > TestSpriteC", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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

			_selector = new Selector("TestSpriteA TestSpriteC", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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

			_selector = new Selector("TestSpriteA TestSpriteC", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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

			_selector = new Selector("*:root", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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

			_selector = new Selector("*:root > *:first-child", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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

			_selector = new Selector("*:root > *:last-child", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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

			_selector = new Selector("*:root > *:nth-child(6)", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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

			_selector = new Selector("*:root > *:nth-child(-2n + 5)", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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

			_selector = new Selector("*:root > *:nth-last-child(3)", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

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
			_propertyDictionary.aItem("testattrib", values);

			var propertyName:String = "id";
			var value:String = "testName";
			_propertyDictionary.aItem(propertyName, value);

			_selector = new Selector("*:root > *#testName[testattrib~='1234']", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();
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

			/*IMPORTANT: We need to a ":root >" in front of the selector under test. Otherwise
			 the contextView (which is :root in this case) is ALSO matched, which might lead to erratic
			 behaviour (since we don't know how many siblings contextView has on the stage) (arneschroppe 23/12/11)
			 */
			_selector = new Selector(":root > :nth-child(2)", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();


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

			_selector = new Selector(":root > ^Sprite", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();


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

			_selector = new Selector("(fixtures.*.TestSpritePack)", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();


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

			_selector = new Selector(":root > ^TestInterface", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

			assertThat(matchedObjects.size, equalTo(2));
			assertThat(matchedObjects, containsExactly(2, isA(TestSpriteWithInterface)));
		}

		[Test]
		public function isA_selector_should_have_lower_specificity_than_element_selector():void {

			var isASelector:Selector = new Selector("^TestSpriteA", _selectorContext);
			var elementSelector:Selector = new Selector("TestSpriteA", _selectorContext);

			assertThat(isASelector.specificity.isLessThan(elementSelector.specificity), isTrue());

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

			_selector = new Selector("TestSpriteA, TestSpriteB", _selectorContext);
			var matchedObjects:Set = _selector.getMatchedObjects();

			assertThat(matchedObjects.size, equalTo(6));
			assertThat(matchedObjects, containsExactly(2, isA(TestSpriteA)));
			assertThat(matchedObjects, containsExactly(4, isA(TestSpriteB)));
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

import net.wooga.uiengine.displaylistselector.IExternalPropertySource;

import org.as3commons.collections.Set;

class PropertyDictionary implements IExternalPropertySource {

	private var _values:Dictionary = new Dictionary();

	public function aItem(key:String, value:*):void {
		_values[key] = value;
	}

	public function stringValueForProperty(subject:DisplayObject, name:String):String {
		return _values[name];
	}

	public function collectionValueForProperty(subject:DisplayObject, name:String):Set {
		return _values[name];
	}
}
