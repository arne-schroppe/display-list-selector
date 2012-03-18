package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class FirstChild extends NthChild {


		override public function isMatching(subject:ISelectorAdapter):Boolean {
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
