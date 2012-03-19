package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.pseudoclasses.nthchildren.NthOfX;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class NthChild extends NthOfX {


		override protected function indexOfObject(subject:SelectorAdapter):int {
			return subject.getElementIndex();
		}
	}
}
