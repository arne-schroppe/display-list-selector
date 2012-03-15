package net.wooga.displaylistselector.pseudoclasses {

	import net.wooga.displaylistselector.pseudoclasses.nthchildren.NthOfX;
	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

	public class NthLastChild extends NthOfX {

		override protected function indexOfObject(subject:ISelectorAdapter):int {
			return subject.getNumberOfElements() - subject.getElementIndex() - 1;
		}
	}
}
