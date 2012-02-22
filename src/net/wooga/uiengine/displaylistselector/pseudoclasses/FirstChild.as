package net.wooga.uiengine.displaylistselector.pseudoclasses {

	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public class FirstChild extends NthChild {


		override public function isMatching(subject:IStyleAdapter):Boolean {
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
