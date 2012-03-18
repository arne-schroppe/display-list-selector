package net.wooga.fixtures {

	import flash.display.Sprite;

	import net.wooga.utils.flexunit.FlexUnitUtils;

	public class ContextViewBasedTest {

		private var _contextView:Sprite;

		public function get contextView():Sprite {
			return _contextView;
		}

		[Before]
		public function setUp():void {
			addContextViewToStage();
		}


		[After]
		public function tearDown():void {
			removeContextViewFromStage();
		}


		private function addContextViewToStage():void {
			_contextView = new Sprite();
			FlexUnitUtils.stage.addChild(_contextView);
		}


		private function removeContextViewFromStage():void {
			FlexUnitUtils.stage.removeChild(_contextView);
			_contextView = null;
		}

	}
}
