package net.wooga.selectors.matching.matchers {

	import flash.display.DisplayObject;

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.selectors.matching.matchers.implementations.PseudoClassMatcher;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.fixtures.tools.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.tools.getAdapterForObject;

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

		private function getAdapterForObjectAtIndex(index:int):SelectorAdapter {
			var object:DisplayObject = contextView.getChildAt(index);
			return getAdapterForObject(object);
		}

	}
}

import net.wooga.selectors.pseudoclasses.PseudoClass;
import net.wooga.selectors.selectoradapter.SelectorAdapter;
import net.wooga.fixtures.TestSpriteC;

class TestPseudoClass implements PseudoClass {

	public function setArguments(arguments:Array):void {
	}

	public function isMatching(subject:SelectorAdapter):Boolean {
		return subject.getAdaptedElement() is TestSpriteC;
	}
}
