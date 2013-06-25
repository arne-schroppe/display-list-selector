package net.wooga.selectors.tools {

	import net.wooga.selectors.specificity.ISpecificity;
	import net.wooga.selectors.selectors.ISelector;

	public class SpecificityComparator  {
		
		public static function staticCompare(item1:*,  item2:*):int {
			var specificity1:ISpecificity = (item1 as ISelector).specificity;
			var specificity2:ISpecificity = (item2 as ISelector).specificity;

			return specificity1.compare(specificity2);
		}
	}
}
