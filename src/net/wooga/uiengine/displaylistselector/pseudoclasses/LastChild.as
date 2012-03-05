package net.wooga.uiengine.displaylistselector.pseudoclasses {

	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	public class LastChild extends NthLastChild {

		override public function isMatching(subject:ISelectorAdapter):Boolean {
			super.setArguments([1]);
			return super.isMatching(subject);
		}

		override public function setArguments(arguments:Array):void {
			if (arguments.length != 0) {
				throw new ArgumentError("Wrong argument count");
			}
		}
	}
}
