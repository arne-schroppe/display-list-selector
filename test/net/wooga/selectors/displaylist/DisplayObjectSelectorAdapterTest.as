package net.wooga.selectors.displaylist {

	import flash.display.Sprite;

	import net.wooga.fixtures.tools.ContextViewBasedTest;
	import net.wooga.selectors.selectoradapter.SelectorAdapterEvent;

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
			assertThat(_adapter.isHovered(), equalTo(false));
			adaptedSprite.dispatchEvent(new SelectorAdapterEvent(SelectorAdapterEvent.SET_HOVER_STATE, true));
			assertThat(_adapter.isHovered(), equalTo(true));
			adaptedSprite.dispatchEvent(new SelectorAdapterEvent(SelectorAdapterEvent.SET_HOVER_STATE, false));
			assertThat(_adapter.isHovered(), equalTo(false));
		}



		[Test]
		public function should_change_active_state():void {
			assertThat(_adapter.isActive(), equalTo(false));
			adaptedSprite.dispatchEvent(new SelectorAdapterEvent(SelectorAdapterEvent.SET_ACTIVE_STATE, true));
			assertThat(_adapter.isActive(), equalTo(true));
			adaptedSprite.dispatchEvent(new SelectorAdapterEvent(SelectorAdapterEvent.SET_ACTIVE_STATE, false));
			assertThat(_adapter.isActive(), equalTo(false));
		}


		[Test]
		public function should_change_focused_state():void {
			assertThat(_adapter.isFocused(), equalTo(false));
			adaptedSprite.dispatchEvent(new SelectorAdapterEvent(SelectorAdapterEvent.SET_ACTIVE_STATE, true));
			assertThat(_adapter.isActive(), equalTo(true));
			adaptedSprite.dispatchEvent(new SelectorAdapterEvent(SelectorAdapterEvent.SET_ACTIVE_STATE, false));
			assertThat(_adapter.isActive(), equalTo(false));
		}
	}
}
