package net.wooga.uiengine.displaylistselector.matchers.implementations {
	import net.arneschroppe.displaytreebuilder.DisplayTreeBuilder;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;

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
				.end;

			_matcher = new PseudoClassMatcher(new TestPseudoClass());

			var matchedObjects:Array = [];

			for(var i:int = 0; i < contextView.numChildren; ++i) {
				if(_matcher.isMatching(contextView.getChildAt(i))) {
					matchedObjects.push(contextView.getChildAt(i));
				}

			}

			assertThat(matchedObjects, everyItem(isA(TestSpriteC)));
			assertThat(matchedObjects.length, equalTo(3));

		}

	}
}

import flash.display.DisplayObject;

import net.wooga.fixtures.TestSpriteC;
import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;

class TestPseudoClass implements IPseudoClass {

	public function setArguments(arguments:Array):void {
	}

	public function isMatching(subject:DisplayObject):Boolean {
		return subject is TestSpriteC;
	}
}
