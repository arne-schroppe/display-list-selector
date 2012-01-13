package net.wooga.uiengine.displaylistselector.selectorcomparator {
	import net.wooga.uiengine.displaylistselector.stuff.DisplayListSelectorMatcher;

	import org.as3commons.collections.framework.IComparator;

	public class SelectorComparator implements IComparator {

		private var _selectorParser:DisplayListSelectorMatcher;

		public function SelectorComparator(selectorParser:DisplayListSelectorMatcher) {
			_selectorParser = selectorParser;
		}

		public function compare(item1:*, item2:*):int {
			var item1Specificity:Number = _selectorParser.getSpecificityForSelector(item1);
			var item2Specificity:Number = _selectorParser.getSpecificityForSelector(item2);

			if (item1Specificity < item2Specificity) {
				return -1;
			}
			else if (item1Specificity > item2Specificity) {
				return 1;
			}

			return 0;

		}
	}

}
