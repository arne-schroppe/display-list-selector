package net.wooga.selectors.usagepatterns.implementations {

	import net.wooga.selectors.usagepatterns.Selector;
	import net.wooga.selectors.usagepatterns.SelectorGroup;

	public class SelectorGroupImpl implements SelectorGroup {
		private var _selectors:Vector.<Selector>;

		public function SelectorGroupImpl(selectors:Vector.<Selector>) {
			_selectors = selectors;

		}

		public function isAnySelectorMatching(object:Object):Boolean {
			for each(var selector:Selector in _selectors) {
				if(selector.isMatching(object)) {
					return true;
				}
			}

			return false;
		}

		public function get length():int {
			return _selectors.length;
		}

		public function getSelectorAtIndex(index:int):Selector {
			return _selectors[index];
		}
	}
}
