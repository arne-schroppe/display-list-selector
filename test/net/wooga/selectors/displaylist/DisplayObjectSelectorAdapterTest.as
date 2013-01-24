package net.wooga.selectors.displaylist {

	import flash.display.Sprite;

	import net.wooga.fixtures.tools.ContextViewBasedTest;
	import net.wooga.selectors.pseudoclasses.names.PseudoClassName;
	import net.wooga.selectors.selectoradapter.SelectorPseudoClassEvent;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class DisplayObjectSelectorAdapterTest extends ContextViewBasedTest {

		private var _adapter:DisplayObjectSelectorAdapter;

		public var adaptedSprite:Sprite;


		override public function setUp():void {
			super.setUp();
			_adapter = new DisplayObjectSelectorAdapter();

			adaptedSprite = new Sprite();
			contextView.addChild(adaptedSprite);
			_adapter.register(adaptedSprite);
		}

		[Test]
		public function should_change_hover_state():void {
			assertThat(_adapter.hasPseudoClass(PseudoClassName.HOVER), equalTo(false));
			adaptedSprite.dispatchEvent(new SelectorPseudoClassEvent(SelectorPseudoClassEvent.ADD_PSEUDO_CLASS, PseudoClassName.HOVER));
			assertThat(_adapter.hasPseudoClass(PseudoClassName.HOVER), equalTo(true));
			adaptedSprite.dispatchEvent(new SelectorPseudoClassEvent(SelectorPseudoClassEvent.REMOVE_PSEUDO_CLASS, PseudoClassName.HOVER));
			assertThat(_adapter.hasPseudoClass(PseudoClassName.HOVER), equalTo(false));
		}



		[Test]
		public function should_change_active_state():void {
			assertThat(_adapter.hasPseudoClass(PseudoClassName.ACTIVE), equalTo(false));
			adaptedSprite.dispatchEvent(new SelectorPseudoClassEvent(SelectorPseudoClassEvent.ADD_PSEUDO_CLASS, PseudoClassName.ACTIVE));
			assertThat(_adapter.hasPseudoClass(PseudoClassName.ACTIVE), equalTo(true));
			adaptedSprite.dispatchEvent(new SelectorPseudoClassEvent(SelectorPseudoClassEvent.REMOVE_PSEUDO_CLASS, PseudoClassName.ACTIVE));
			assertThat(_adapter.hasPseudoClass(PseudoClassName.ACTIVE), equalTo(false));
		}


		[Test]
		public function should_change_focused_state():void {
			assertThat(_adapter.hasPseudoClass(PseudoClassName.FOCUS), equalTo(false));
			adaptedSprite.dispatchEvent(new SelectorPseudoClassEvent(SelectorPseudoClassEvent.ADD_PSEUDO_CLASS, PseudoClassName.FOCUS));
			assertThat(_adapter.hasPseudoClass(PseudoClassName.FOCUS), equalTo(true));
			adaptedSprite.dispatchEvent(new SelectorPseudoClassEvent(SelectorPseudoClassEvent.REMOVE_PSEUDO_CLASS, PseudoClassName.FOCUS));
			assertThat(_adapter.hasPseudoClass(PseudoClassName.FOCUS), equalTo(false));
		}
	}
}
