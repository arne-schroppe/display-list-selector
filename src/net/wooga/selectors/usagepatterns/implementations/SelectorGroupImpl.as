package net.wooga.selectors.usagepatterns.implementations {

	import net.wooga.selectors.usagepatterns.Selector;
	import net.wooga.selectors.usagepatterns.SelectorGroup;

	public class SelectorGroupImpl implements SelectorGroup {
		private var _selectors:Vector.<Selector>;

		public function SelectorGroupImpl(selectors:Vector.<Selector>) {
			_selectors = selectors;

		}

		public function get selectors():Vector.<Selector> {
			return _selectors;
		}

		public function isAnySelectorMatching(object:Object):Boolean {
			for each(var selector:Selector in _selectors) {
				if(selector.isMatching(object)) {
					return true;
				}
			}

			return false;
		}
	}
}
