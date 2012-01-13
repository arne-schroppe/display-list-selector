package net.wooga.uiengine.displaylistselector.pseudoclasses {

	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.pseudoclasses.nthchildren.NthChildArgumentParser;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.nthchildren.NthOfX;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.nthchildren.NthParserResult;

	public class NthChild extends NthOfX {


		override protected function indexOfObject(subject:DisplayObject):int {
			return subject.parent.getChildIndex(subject);
		}
	}
}
