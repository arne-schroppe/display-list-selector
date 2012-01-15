package net.wooga.uiengine.displaylistselector.selectorcomparator {

	import net.wooga.uiengine.displaylistselector.Selector;

	import org.as3commons.collections.framework.IComparator;

	public class SelectorComparator implements IComparator {


		public function compare(item1:*, item2:*):int {
			var item1Specificity:Number = (item1 as Selector).specificity;
			var item2Specificity:Number = (item2 as Selector).specificity;

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
