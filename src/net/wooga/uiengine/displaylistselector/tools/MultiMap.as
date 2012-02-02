package net.wooga.uiengine.displaylistselector.tools {
	import org.as3commons.collections.Map;

	public class MultiMap {
		private var _numberOfLevels:int;
		private var _levels:Map = new Map();


		public function MultiMap(numberOfLevels:int = 2) {
			_numberOfLevels = numberOfLevels;
		}


		public function itemFor(...args):* {

			var currentLevel:Map = _levels;
			var key:*;

			for (var i:int = 0; i < _numberOfLevels; ++i) {

				var isLastLevel:Boolean = (i == _numberOfLevels - 1);
				key = args[i];

				if (!currentLevel.hasKey(key)) {
					return null;
				}

				if (!isLastLevel) {
					currentLevel = currentLevel.itemFor(key);
				}
			}

			return currentLevel.itemFor(key);
		}


		public function addOrReplace(...args):void {
			var currentLevel:Map = _levels;
			var value:* = args[args.length - 1];

			for (var i:int = 0; i < _numberOfLevels; ++i) {

				var key:* = args[i];

				var isLastLevel:Boolean = (i == _numberOfLevels - 1);

				if (isLastLevel) {
					if (currentLevel.hasKey(key)) {
						currentLevel.replaceFor(key, value);
					} else {
						currentLevel.add(key, value);
					}
				} else {

					if (!currentLevel.hasKey(key)) {
						currentLevel.add(key, new Map());
					}

					currentLevel = currentLevel.itemFor(key);
				}
			}
		}
	}
}
