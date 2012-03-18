package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class IsEmpty implements IPseudoClass {

		public function isMatching(subject:ISelectorAdapter):Boolean {
			return subject.isEmpty();
		}

		public function setArguments(arguments:Array):void {
			if (arguments.length != 0) {
				throw new ArgumentError("Wrong argument count");
			}
		}
	}
}
