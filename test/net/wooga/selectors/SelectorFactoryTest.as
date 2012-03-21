package net.wooga.selectors {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.selectors.usagepatterns.Selector;
	import net.wooga.selectors.usagepatterns.SelectorDescription;
	import net.wooga.selectors.usagepatterns.SelectorGroup;
	import net.wooga.selectors.usagepatterns.SelectorPool;
	import net.wooga.selectors.displaylist.DisplayObjectSelectorAdapter;
	import net.wooga.fixtures.tools.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.TestSpriteWithInterface;
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

	//TODO (arneschroppe 22/2/12) maybe we should rewrite these tests with mocked adapters instead of using the DisplayObjectStyleAdapter
	public class SelectorFactoryTest extends ContextViewBasedTest {


		private var _selectorFactory:AbstractSelectorFactory;
		private var _selectorPool:SelectorPool;

		private var _displayList:DisplayTree;
		private var _propertyDictionary:PropertyDictionary;

		override public function setUp():void {
			super.setUp();
			_propertyDictionary = new PropertyDictionary();
			_displayList = new DisplayTree();

			_selectorFactory = new AbstractSelectorFactory();
			_selectorFactory.initializeWith(contextView, _propertyDictionary);
			_selectorFactory.setDefaultStyleAdapter(DisplayObjectSelectorAdapter);


		}


		[Test]
		public function should_match_element_selector():void {

			_displayList.uses(contextView).containing
				.a(TestSpriteA)
				.a(TestSpriteB)
				.a(TestSpriteC)
			.end.finish();


			testSelector("TestSpriteB", function(matchedObjects:Set):void {
				assertContainsObjectOfClass(matchedObjects, TestSpriteB);
				assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteA);
				assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteC);	
				
			});
		}


		[Test]
		public function should_match_any_selector():void {

			_displayList.uses(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteC)
				.end.finish();


			testSelector("*", function(matchedObjects:Set):void {

				assertContainsObjectOfClass(matchedObjects, TestSpriteA);
				assertContainsObjectOfClass(matchedObjects, TestSpriteB);
				assertContainsObjectOfClass(matchedObjects, TestSpriteC);
			})
		}


		[Test]
		public function should_match_nested_class():void {

			_displayList.uses(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB).containing
						.a(TestSpriteC)
					.end
					.a(TestSpriteC)
				.end.finish();

			testSelector("TestSpriteB > TestSpriteC", function(matchedObjects:Set):void {
				assertContainsObjectOfClass(matchedObjects, TestSpriteC);
				assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteA);
				assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteB);
				assertEquals(1, matchedObjects.size);
			})
		}


		[Test]
		public function should_match_class_with_name():void {

			var expectedName:String = "test1234";

			_displayList.uses(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB).containing
						.a(TestSpriteC)
					.end
					.a(TestSpriteC).withTheName(expectedName)
				.end.finish();

			testSelector("TestSpriteC[name='" + expectedName + "']", function(matchedObjects:Set):void {
				assertThat(matchedObjects, hasItemInCollection(allOf(isA(TestSpriteC), hasPropertyWithValue("name", expectedName))));
				assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteA);
				assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteB);
				assertEquals(1, matchedObjects.size);
			});
		}


		[Test]
		public function should_match_class_with_external_property():void {

			_displayList.uses(contextView).containing
					.a(TestSpriteA)
				.end.finish();

			var propertyName:String = "obscureExternalProperty";
			var value:String = "success";

			_propertyDictionary.addItem(propertyName, value);
			testSelector("TestSpriteA[" + propertyName + "='" + value + "']", function(matchedObjects:Set):void {
				assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));
				assertEquals(1, matchedObjects.size);
			});
		}


		//TODO (arneschroppe 22/2/12) we are relying on a specific implementation of IStyleAdapter here, which is unfortunate
		[Test]
		public function should_match_css_id_selector():void {

			_displayList.uses(contextView).containing
					.a(TestSpriteA).withTheName("test")
				.end.finish();


			testSelector("TestSpriteA#test", function(matchedObjects:Set):void {
				assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));
				assertEquals(1, matchedObjects.size);
			});
		}


		[Test]
		public function should_match_oneof_selector():void {

			_displayList.uses(contextView).containing
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

			testSelector("TestSpriteA[state~='expectedValue']", function(matchedObjects:Set):void {
				assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));
				assertEquals(1, matchedObjects.size);
			});
		}


		[Test]
		public function should_match_cssclass_selector():void {

			_displayList.uses(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteC).withTheProperty("groups").setToThe.value(["A", "B", "testClass", "C"])
				.end.finish();

			testSelector("TestSpriteC.testClass", function(matchedObjects:Set):void {
				assertThat(matchedObjects, containsExactly(1, isA(TestSpriteC)));
				assertEquals(1, matchedObjects.size);
			});
		}


		[Test]
		public function should_match_different_branches():void {

			_displayList.uses(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB).containing
						.a(TestSpriteC)
					.end
					.a(TestSpriteA).containing
						.a(TestSpriteC)
					.end
				.end.finish();

			testSelector("* > TestSpriteC", function(matchedObjects:Set):void {
				assertThat(matchedObjects, containsExactly(2, isA(TestSpriteC)));
				assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteA);
				assertDoesNotContainObjectOfClass(matchedObjects, TestSpriteB);
				assertEquals(2, matchedObjects.size);
			});
		}


		[Test]
		public function should_match_descendant_objects():void {

			_displayList.uses(contextView).containing
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

			testSelector("TestSpriteA TestSpriteC", function(matchedObjects:Set):void {
				assertThat(matchedObjects, containsExactly(3, isA(TestSpriteC)));
				assertEquals(3, matchedObjects.size);
			});
		}



		[Test]
		public function should_match_contrived_descendant_objects():void {

			_displayList.uses(contextView).containing
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

			testSelector("TestSpriteA TestSpriteC", function(matchedObjects:Set):void {
				assertThat(matchedObjects, containsExactly(4, isA(TestSpriteC)));
				assertEquals(4, matchedObjects.size);
			});
		}



		[Test]
		public function should_match_root_pseudo_class():void {

			_displayList.uses(contextView).containing
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

			testSelector("*:root", function(matchedObjects:Set):void {
				assertThat(matchedObjects, containsExactly(1, equalTo(contextView)));
				assertEquals(1, matchedObjects.size);
			});
		}


		[Test]
		public function should_match_firstchild_pseudo_class():void {

			_displayList.uses(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteC)
				.end.finish();

			testSelector("*:first-child", function(matchedObjects:Set):void {
				assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));
				assertEquals(1, matchedObjects.size);
			});
		}


		[Test]
		public function should_match_lastchild_pseudo_class():void {

			_displayList.uses(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteC)
				.end.finish();

			testSelector("*:root > *:last-child", function(matchedObjects:Set):void {
				assertThat(matchedObjects, containsExactly(1, isA(TestSpriteC)));
				assertEquals(1, matchedObjects.size);
			});
		}


		[Test]
		public function should_match_nthchild_pseudo_class():void {

			_displayList.uses(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteA)
					.a(TestSpriteA)
				.end.finish();


			testSelector("*:nth-child(6)", function(matchedObjects:Set):void {
				assertThat(matchedObjects, containsExactly(1, isA(TestSpriteB)));
				assertThat(matchedObjects.size, equalTo(1));
			});
		}


		[Test]
		public function should_match_nthchild_pseudo_class_with_complex_argument():void {

			_displayList.uses(contextView).containing
					.a(TestSpriteB)
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.end.finish();

			testSelector("*:nth-child(-2n + 5)", function(matchedObjects:Set):void {
				assertThat(matchedObjects, containsExactly(3, isA(TestSpriteB)));
				assertEquals(3, matchedObjects.size);
			});
		}


		[Test]
		public function should_match_nthlastchild_pseudo_class():void {

			_displayList.uses(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteA)
					.a(TestSpriteA)
				.end.finish();


			testSelector("*:nth-last-child(3)", function(matchedObjects:Set):void {
				assertThat(matchedObjects, containsExactly(1, isA(TestSpriteB)));
				assertThat(matchedObjects.size, equalTo(1));
			});
		}


		[Test]
		public function should_match_id_and_attribute_selector():void {

			_displayList.uses(contextView).containing
					.a(TestSpriteC).withTheName("testName")
				.end.finish();

			var values:Set = new Set();
			values.add("A");
			values.add("B");
			values.add("1234");
			values.add("C");
			_propertyDictionary.addItem("testattrib", values);

			testSelector(":root > *#testName[testattrib~='1234']", function(matchedObjects:Set):void {
				assertThat(matchedObjects.size, equalTo(1));
				assertThat(matchedObjects, containsExactly(1, isA(TestSpriteC)));
			});
		}


		[Test]
		public function should_match_selectors_without_element_selector():void {
			_displayList.uses(contextView).containing
					.a(TestSpriteA)
					.a(TestSpriteB)
					.a(TestSpriteC)
				.end.finish();

			testSelector(":root > :nth-child(2)", function(matchedObjects:Set):void {
				assertThat(matchedObjects.size, equalTo(1));
				assertThat(matchedObjects, containsExactly(1, isA(TestSpriteB)));
			});
		}

		[Test]
		public function should_match_isA_selector():void {

			_displayList.uses(contextView).containing
					.a(TestSpriteA)
					.a(MovieClip)
					.a(MovieClip)
					.a(TestSpriteB)
				.end.finish();


			testSelector(":root > ^Sprite", function(matchedObjects:Set):void {
				assertThat(matchedObjects.size, equalTo(4));
				assertThat(matchedObjects, containsExactly(1, isA(TestSpriteA)));
				assertThat(matchedObjects, containsExactly(2, isA(MovieClip)));
				assertThat(matchedObjects, containsExactly(1, isA(TestSpriteB)));
			});
		}


		[Test]
		public function should_match_interface():void {

			_displayList.uses(contextView).containing
					.a(TestSpriteWithInterface)
					.a(TestSpriteA)
					.a(TestSpriteA)
					.a(TestSpriteWithInterface)
					.end.finish();

			testSelector(":root > ^TestInterface", function(matchedObjects:Set):void {
				assertThat(matchedObjects.size, equalTo(2));
				assertThat(matchedObjects, containsExactly(2, isA(TestSpriteWithInterface)));
			});
		}





		[Test]
		public function isA_selector_should_have_lower_specificity_than_element_selector():void {

			var isASelector:Selector = _selectorFactory.createSelector("^TestSpriteA").selectors[0];
			var elementSelector:Selector = _selectorFactory.createSelector("TestSpriteA").selectors[0];

			assertThat(isASelector.specificity.isLessThan(elementSelector.specificity), isTrue());
		}


		[Test]
		public function should_have_a_comma_separator_to_select_the_union_of_several_selectors():void {

			_displayList.uses(contextView).containing
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


			testSelector("TestSpriteA, TestSpriteB", function(matchedObjects:Set):void {
				assertThat(matchedObjects.size, equalTo(6));
				assertThat(matchedObjects, containsExactly(2, isA(TestSpriteA)));
				assertThat(matchedObjects, containsExactly(4, isA(TestSpriteB)));
			});
		}


		[Test]
		public function should_build_match_tree_properly():void {
			_displayList.uses(contextView).containing
					.a(TestSpriteA).containing
						.a(TestSpriteB).containing
							.times(3).a(TestSpriteC)
						.end
					.end
				.end.finish();


			testSelector("TestSpriteB TestSpriteC:first-child, TestSpriteB > TestSpriteC", function(matchedObjects:Set):void {
				assertThat(matchedObjects.size, equalTo(3));
				assertThat(matchedObjects, containsExactly(3, isA(TestSpriteC)));
			});
		}




		private function assertContainsObjectOfClass(objects:IIterable, Type:Class):void {
			assertThat(objects, hasItemInCollection(isA(Type)));
		}


		private function assertDoesNotContainObjectOfClass(objects:IIterable, Type:Class):void {
			assertThat(objects, everyItemInCollection(not(isA(Type))));
		}


		private function testSelector(selectorString:String, assertions:Function):void {



			var result:Set = getMatchedObjectsFromSelectorPool(selectorString);
			assertions.call(this, result);

			result = getMatchedObjectsFromSingleSelector(selectorString);
			assertions.call(this, result);
		}



		private function getMatchedObjectsFromSelectorPool(selectorString:String):Set {
			_selectorPool = _selectorFactory.createSelectorPool();
			_selectorPool.addSelector(selectorString);
			var result:Set = new Set();

			scanForMatches(contextView, selectorString, result, selectorPoolMatchMethod);

			return result;
		}


		private function scanForMatches(object:DisplayObject, selectorString:String, result:Set, matchMethod:Function):void {

			_selectorFactory.createStyleAdapterFor(object);

			matchMethod(object, selectorString, result);
			var container:DisplayObjectContainer = object as DisplayObjectContainer;
			if(container) {
				for(var i:int = 0; i< container.numChildren; ++i) {
					scanForMatches(container.getChildAt(i), selectorString, result, matchMethod);
				}
			}
		}

		private function selectorPoolMatchMethod(object:DisplayObject, selectorString:String, result:Set):void {
			var matchingSelectors:Vector.<SelectorDescription> = _selectorPool.getSelectorsMatchingObject(object);
			if (matchingSelectors.filter(filterFunctionFor(selectorString)).length > 0) {
				result.add(object);
			}
		}


		private function getMatchedObjectsFromSingleSelector(selectorString:String):Set {
			var result:Set = new Set();
			scanForMatches(contextView, selectorString, result, singleSelectorMatchMethod);
			return result;
		}


		private function singleSelectorMatchMethod(object:DisplayObject, selectorString:String, result:Set):void {
			var selector:SelectorGroup = _selectorFactory.createSelector(selectorString);
			if (selector.isAnySelectorMatching(object)) {
				result.add(object);
			}
		}


		private function filterFunctionFor(selectorString:String):Function {
			return function(item:SelectorDescription, index:int, vector:Vector.<SelectorDescription>):Boolean {
				return item.originalSelectorString == selectorString;
			}
		}

		//TODO (arneschroppe 3/18/12) test that items returned by a selectorpool are sorted by specificity
	}
}

import flash.utils.Dictionary;

import net.wooga.selectors.IExternalPropertySource;
import net.wooga.selectors.selectoradapter.SelectorAdapter;

import org.as3commons.collections.Set;

class PropertyDictionary implements IExternalPropertySource {

	private var _values:Dictionary = new Dictionary();

	public function addItem(key:String, value:*):void {
		_values[key] = value;
	}

	public function stringValueForProperty(subject:SelectorAdapter, name:String):String {
		return _values[name];
	}

	public function collectionValueForProperty(subject:SelectorAdapter, name:String):Set {
		return _values[name];
	}
}
