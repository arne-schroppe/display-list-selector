package net.wooga.speed.profilingsetups  {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import net.wooga.selectors.AbstractSelectorFactory;

	public class BasicProfilingSprite extends Sprite {
		
		
		private var _startButton:TextField;
		private var _status:TextField;

		protected var _selectorFactory:AbstractSelectorFactory;
		
		
		public function BasicProfilingSprite() {

			_selectorFactory = new AbstractSelectorFactory();
			_selectorFactory.initializeWith(this);

			_startButton = new TextField();
			_startButton.selectable = false;
			_startButton.text = "Start";
			_startButton.addEventListener(MouseEvent.CLICK, onStartClicked)
			_startButton.x = 200;
			addChild(_startButton);

			_status = new TextField();
			_status.selectable = false;
			_status.text = "waiting...";
			_status.x = 200;
			_status.y = 100;
			addChild(_status);

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event):void {
			prepare();
		}



		private function onStartClicked(event:MouseEvent):void {

			_status.text = "started";
			performAction();
			_status.text = "finished";
		}


		protected function prepare():void {

		}


		protected function performAction():void {

		}
	}
}
