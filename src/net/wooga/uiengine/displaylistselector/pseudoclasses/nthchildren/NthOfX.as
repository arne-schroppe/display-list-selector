package net.wooga.uiengine.displaylistselector.pseudoclasses.nthchildren {
	import net.wooga.uiengine.displaylistselector.pseudoclasses.*;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import net.wooga.uiengine.displaylistselector.pseudoclasses.nthchildren.NthChildArgumentParser;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.nthchildren.NthParserResult;

	public class NthOfX implements IPseudoClass {

		private var _a:int;
		private var _b:int;
		private var _argumentParser:NthChildArgumentParser = new NthChildArgumentParser();

		public function isMatching(subject:DisplayObject):Boolean {

			if(!subject.parent) {
				return false;
			}

			var targetIndex:int = indexOfObject(subject) + 1;

			if(_a == 0) {
				return targetIndex == _b;
			}
			else {
				var n:Number = (targetIndex - _b) / _a;
				return n % 1 == 0 && n >= 0;
			}
		}

		protected function indexOfObject(subject:DisplayObject):int {
			throw new Error("Must be implemented by subclass");
		}

		public function setArguments(arguments:Array):void {
			if (arguments.length != 1) {
				throw new ArgumentError("Wrong argument count");
			}

			var result:NthParserResult = _argumentParser.parse(arguments[0]);
			_a = result.a;
			_b = result.b;
		}
	}
}
