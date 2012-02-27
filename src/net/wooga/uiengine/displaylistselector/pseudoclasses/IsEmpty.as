package net.wooga.uiengine.displaylistselector.pseudoclasses {

	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public class IsEmpty implements IPseudoClass {

		public function isMatching(subject:IStyleAdapter):Boolean {
			return subject.isEmpty();
		}

		public function setArguments(arguments:Array):void {
			if (arguments.length != 0) {
				throw new ArgumentError("Wrong argument count");
			}
		}
	}
}
