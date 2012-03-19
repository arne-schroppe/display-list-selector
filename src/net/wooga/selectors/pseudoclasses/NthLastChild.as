package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.pseudoclasses.nthchildren.NthOfX;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class NthLastChild extends NthOfX {

		override protected function indexOfObject(subject:SelectorAdapter):int {
			return subject.getNumberOfElements() - subject.getElementIndex() - 1;
		}
	}
}
