package net.wooga.displaylistselector.pseudoclasses {

	import net.wooga.displaylistselector.pseudoclasses.nthchildren.NthOfX;
	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

	public class NthChild extends NthOfX {


		override protected function indexOfObject(subject:ISelectorAdapter):int {
			return subject.getElementIndex();
		}
	}
}
