package net.wooga.selectors.selectors.implementations {

	import net.wooga.selectors.selectors.ISelector;
	import net.wooga.selectors.selectors.ISelectorGroup;

	public class SelectorGroup implements ISelectorGroup {
		private var _selectors:Vector.<ISelector>;

		public function SelectorGroup(selectors:Vector.<ISelector>) {
			_selectors = selectors;

		}

		public function isAnySelectorMatching(object:Object):Boolean {
			for each(var selector:ISelector in _selectors) {
				if(selector.isMatching(object)) {
					return true;
				}
			}

			return false;
		}

		public function get length():int {
			return _selectors.length;
		}

		public function getSelectorAtIndex(index:int):ISelector {
			return _selectors[index];
		}
	}
}
