package net.wooga.displaylistselector.pseudoclasses {
	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

	public class Active implements IPseudoClass {

		public function isMatching(subject:ISelectorAdapter):Boolean {
			return subject.isActive();
		}

		public function setArguments(arguments:Array):void {
			if (arguments.length != 0) {
				throw new ArgumentError("Wrong argument count");
			}
		}
	}
}
