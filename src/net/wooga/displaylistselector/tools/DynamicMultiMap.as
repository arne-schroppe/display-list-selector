package net.wooga.displaylistselector.tools {
	import org.as3commons.collections.Map;

	public class DynamicMultiMap {

		private var _root:Map = new Map();

		
		public function itemForKeys(keys:Array):* {

			var currentLevel:Map = _root;
			var key:*;

			for (var i:int = 0; i < keys.length; ++i) {

				var isLastLevel:Boolean = (i == (keys.length - 1));
				key = keys[i];

				if (!currentLevel.hasKey(key)) {
					return null;
				}

				if (!isLastLevel) {
					currentLevel = currentLevel.itemFor(key);
				}
			}

			return currentLevel.itemFor(key);
			
		}


		public function addOrReplace(keys:Array, value:*):void {

			var currentLevel:Map = _root;

			for (var i:int = 0; i < keys.length; ++i) {

				var key:* = keys[i];

				var isLastLevel:Boolean = (i == (keys.length - 1));

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
