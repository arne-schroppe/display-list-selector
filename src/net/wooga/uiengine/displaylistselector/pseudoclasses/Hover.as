package net.wooga.uiengine.displaylistselector.pseudoclasses {

	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	public class Hover implements IPseudoClass {

		public function isMatching(subject:ISelectorAdapter):Boolean {
			return subject.isHovered();
		}

		public function setArguments(arguments:Array):void {
			if (arguments.length != 0) {
				throw new ArgumentError("Wrong argument count");
			}
		}
	}
}
