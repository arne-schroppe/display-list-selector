package net.wooga.uiengine.displaylistselector.pseudoclasses {

	import net.wooga.uiengine.displaylistselector.pseudoclasses.nthchildren.NthOfX;
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	public class NthChild extends NthOfX {


		override protected function indexOfObject(subject:ISelectorAdapter):int {
			return subject.getElementIndex();
		}
	}
}
