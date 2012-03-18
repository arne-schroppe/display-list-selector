package net.wooga.displaylistselector.usagepatterns.implementations {

	import net.wooga.displaylistselector.usagepatterns.Selector;
	import net.wooga.displaylistselector.usagepatterns.SelectorGroup;

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
