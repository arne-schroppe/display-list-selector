package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.AdapterSource;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class FirstOfType extends NthOfType {

		public function FirstOfType(adapterSource:AdapterSource) {
			super(adapterSource);
		}


		override public function isMatching(subject:SelectorAdapter):Boolean {
			super.setArguments(["1"]);
			return super.isMatching(subject);
		}

		override public function setArguments(arguments:Array):void {
			if (arguments.length != 0) {
				throw new ArgumentError("Wrong argument count");
			}

		}


	}
}
