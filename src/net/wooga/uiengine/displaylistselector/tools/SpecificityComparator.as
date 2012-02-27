package net.wooga.uiengine.displaylistselector.tools {
	import net.wooga.uiengine.displaylistselector.ISpecificity;
	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;

	import org.as3commons.collections.framework.IComparator;

	public class SpecificityComparator implements IComparator {


		public function compare(item1:*, item2:*):int {
			var specificity1:ISpecificity = (item1 as ParsedSelector).specificity;
			var specificity2:ISpecificity = (item2 as ParsedSelector).specificity;

			return specificity1.compare(specificity2);
		}
	}
}
