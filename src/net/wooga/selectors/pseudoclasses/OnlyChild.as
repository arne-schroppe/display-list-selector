package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class OnlyChild implements PseudoClass {

		public function setArguments(arguments:Array):void {
			if (arguments.length != 0) {
				throw new ArgumentError("Wrong argument count");
			}
		}

		public function isMatching(subject:SelectorAdapter):Boolean {
			return subject.getNumberOfElementsInContainer() == 1;
		}
	}
}
