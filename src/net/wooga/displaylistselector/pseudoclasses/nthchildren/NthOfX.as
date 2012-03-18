package net.wooga.displaylistselector.pseudoclasses.nthchildren {

	import net.wooga.displaylistselector.pseudoclasses.IPseudoClass;
	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

	public class NthOfX implements IPseudoClass {

		private var _a:int;
		private var _b:int;
		private var _argumentParser:NthChildArgumentParser = new NthChildArgumentParser();

		public function isMatching(subject:ISelectorAdapter):Boolean {

			var targetIndex:int = indexOfObject(subject) + 1;

			if(_a == 0) {
				return targetIndex == _b;
			}
			else {
				var n:Number = (targetIndex - _b) / _a;
				return n % 1 == 0 && n >= 0;
			}
		}

		protected function indexOfObject(subject:ISelectorAdapter):int {
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
