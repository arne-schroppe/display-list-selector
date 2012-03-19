package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class Hover implements PseudoClass {

		public function isMatching(subject:SelectorAdapter):Boolean {
			return subject.isHovered();
		}

		public function setArguments(arguments:Array):void {
			if (arguments.length != 0) {
				throw new ArgumentError("Wrong argument count");
			}
		}
	}
}
