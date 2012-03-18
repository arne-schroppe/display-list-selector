package net.wooga.displaylistselector.tools {

	import net.wooga.displaylistselector.ISpecificity;
	import net.wooga.displaylistselector.usagepatterns.SelectorDescription;

	import org.as3commons.collections.framework.IComparator;

	public class SpecificityComparator implements IComparator {


		public function compare(item1:*, item2:*):int {
			return staticCompare(item1, item2);
		}
		
		public static function staticCompare(item1:*,  item2:*):int {
			var specificity1:ISpecificity = (item1 as SelectorDescription).specificity;
			var specificity2:ISpecificity = (item2 as SelectorDescription).specificity;

			return specificity1.compare(specificity2);
		}
	}
}
