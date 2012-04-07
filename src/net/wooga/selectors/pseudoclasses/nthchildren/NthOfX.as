package net.wooga.selectors.pseudoclasses.nthchildren {

	import net.wooga.selectors.pseudoclasses.PseudoClass;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;


	//TODO (arneschroppe 08/04/2012) both nth-child and nth-of-type should become faster (i.e. no looping in nth-of-type). They should also ignore elements without adapters and match strictly by same type, with an option to also recognize super classes and interfaces
	public class NthOfX implements PseudoClass {

		private var _a:int;
		private var _b:int;
		private var _argumentParser:NthChildArgumentParser = new NthChildArgumentParser();

		public function isMatching(subject:SelectorAdapter):Boolean {

			var targetIndex:int = indexOfObject(subject) + 1;

			if(_a == 0) {
				return targetIndex == _b;
			}
			else {
				var n:Number = (targetIndex - _b) / _a;
				return n % 1 == 0 && n >= 0;
			}
		}

		protected function indexOfObject(subject:SelectorAdapter):int {
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
