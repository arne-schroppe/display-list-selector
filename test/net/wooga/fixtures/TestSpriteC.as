package net.wooga.fixtures {
	import flash.display.Sprite;

	public class TestSpriteC extends Sprite {
		public function TestSpriteC() {
		}


		private var _groups:Array;
		public function get groups():Array {
			return _groups;
		}

		public function set groups(value:Array):void {
			_groups = value;
		}
	}
}
