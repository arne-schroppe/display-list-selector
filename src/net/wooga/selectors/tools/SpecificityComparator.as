package net.wooga.selectors.tools {

	import net.wooga.selectors.Specificity;
	import net.wooga.selectors.usagepatterns.SelectorDescription;

	public class SpecificityComparator  {
		
		public static function staticCompare(item1:*,  item2:*):int {
			var specificity1:Specificity = (item1 as SelectorDescription).specificity;
			var specificity2:Specificity = (item2 as SelectorDescription).specificity;

			return specificity1.compare(specificity2);
		}
	}
}
