package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class SettablePseudoClass implements IPseudoClass {
		private var _pseudoClassName:String;

		public function SettablePseudoClass(pseudoClassName:String) {
			_pseudoClassName = pseudoClassName;
		}

		public function isMatching(subject:ISelectorAdapter):Boolean {
			return subject.hasPseudoClass(_pseudoClassName);
		}

		public function setArguments(arguments:Array):void {
			if (arguments.length != 0) {
				throw new ArgumentError("Wrong argument count");
			}
		}


		public function get pseudoClassName():String {
			return _pseudoClassName;
		}
	}
}
