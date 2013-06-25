package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.pseudoclasses.nthchildren.NthOfX;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class NthLastChild extends NthOfX {

		override protected function indexOfObject(subject:ISelectorAdapter):int {
			return subject.getNumberOfElementsInContainer() - subject.getElementIndex() - 1;
		}
	}
}
