package net.wooga.selectors.tools {

	import net.wooga.selectors.specificity.Specificity;
	import net.wooga.selectors.selectors.Selector;

	public class SpecificityComparator  {
		
		public static function staticCompare(item1:*,  item2:*):int {
			var specificity1:Specificity = (item1 as Selector).specificity;
			var specificity2:Specificity = (item2 as Selector).specificity;

			return specificity1.compare(specificity2);
		}
	}
}
