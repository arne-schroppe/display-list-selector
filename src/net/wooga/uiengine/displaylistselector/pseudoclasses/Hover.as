package net.wooga.uiengine.displaylistselector.pseudoclasses {
	import flash.display.Stage;
	import flash.geom.Point;

	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public class Hover implements IPseudoClass{

		private var _stage:Stage;
		public function Hover(stage:Stage) {
			_stage = stage;
		}

		public function setArguments(arguments:Array):void {
		}

		public function isMatching(subject:IStyleAdapter):Boolean {
			
			var objects:Array = _stage.getObjectsUnderPoint(new Point(_stage.mouseX, _stage.mouseY))
			return objects[objects.length - 1] == subject;
		}
	}
}
