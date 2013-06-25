package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class OnlyChild implements IPseudoClass {

		public function setArguments(arguments:Array):void {
			if (arguments.length != 0) {
				throw new ArgumentError("Wrong argument count");
			}
		}

		public function isMatching(subject:ISelectorAdapter):Boolean {
			return subject.getNumberOfElementsInContainer() == 1;
		}
	}
}
