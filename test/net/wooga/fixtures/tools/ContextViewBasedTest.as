package net.wooga.fixtures.tools {

	import flash.display.Sprite;
	import flash.display.Stage;

	import mx.core.FlexGlobals;

	import spark.components.Application;


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
			myStage.addChild(_contextView);
		}


		private function removeContextViewFromStage():void {
			myStage.removeChild(_contextView);
			_contextView = null;
		}



		private static function get myStage():Stage {

			var app:Object = FlexGlobals.topLevelApplication;

			return mx.core.Application(app).stage;

			/*
			if (app is mx.core.Application) {
				return mx.core.Application(app).stage;
			} else if (app is spark.components.Application) {
				return spark.components.Application(app).stage;
			} else {
				return null;
			}
			*/

		}

	}
}
