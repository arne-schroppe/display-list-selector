package net.wooga.uiengine.displaylistselector.pseudoclasses {

	import net.wooga.uiengine.displaylistselector.pseudoclasses.nthchildren.NthOfX;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public class NthLastChild extends NthOfX {

		override protected function indexOfObject(subject:IStyleAdapter):int {
			return subject.getNumberOfElements() - subject.getElementIndex() - 1;
		}
	}
}
