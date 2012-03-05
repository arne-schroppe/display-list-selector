package net.wooga.uiengine.displaylistselector.matching.matchers {
	import flash.display.DisplayObject;

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.getAdapterForObject;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.PseudoClassMatcher;
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	import org.hamcrest.assertThat;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;

	public class PseudoClassMatcherTest extends ContextViewBasedTest {

		private var _matcher:PseudoClassMatcher;

		[Before]
		override public function setUp():void {
			super.setUp();
		}

		[After]
		override public function tearDown():void {
			super.tearDown();
		}

		[Test]
		public function should_match_pseudoclass_matches():void {

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

			_matcher = new PseudoClassMatcher(new TestPseudoClass());

			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {
				if(_matcher.isMatching(getAdapterForObjectAtIndex(i))) {
					matchedObjects.push(contextView.getChildAt(i));
				}

			}

			assertThat(matchedObjects, everyItem(isA(TestSpriteC)));
			assertThat(matchedObjects.length, equalTo(3));

		}

		private function getAdapterForObjectAtIndex(index:int):ISelectorAdapter {
			var object:DisplayObject = contextView.getChildAt(index);
			return getAdapterForObject(object);
		}

	}
}

import net.wooga.fixtures.TestSpriteC;
import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;
import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

class TestPseudoClass implements IPseudoClass {

	public function setArguments(arguments:Array):void {
	}

	public function isMatching(subject:ISelectorAdapter):Boolean {
		return subject.getAdaptedElement() is TestSpriteC;
	}
}
