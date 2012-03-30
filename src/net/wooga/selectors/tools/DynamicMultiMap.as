package net.wooga.selectors.tools {

	import flash.utils.Dictionary;

	public class DynamicMultiMap {

		private var _root:Dictionary = new Dictionary();

		
		public function itemForKeys(keys:Array):* {

			var currentLevel:Dictionary = _root;
			var key:*;

			for (var i:int = 0; i < keys.length; ++i) {

				var isLastLevel:Boolean = (i == (keys.length - 1));
				key = keys[i];

				if (!currentLevel.hasOwnProperty(key)) {
					return null;
				}

				if (!isLastLevel) {
					currentLevel = currentLevel[key];
				}
			}

			return currentLevel.itemFor(key);
			
		}


		public function addOrReplace(keys:Array, value:*):void {

			var currentLevel:Dictionary = _root;

			for (var i:int = 0; i < keys.length; ++i) {

				var key:* = keys[i];

				var isLastLevel:Boolean = (i == (keys.length - 1));

				if (isLastLevel) {
					currentLevel[key] = value;
				} else {

					if (!currentLevel.hasOwnProperty(key)) {
						currentLevel[key] = new Dictionary();
					}

					currentLevel = currentLevel[key];
				}
			}
		}

	}
}
