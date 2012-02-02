package net.wooga.uiengine.displaylistselector.parser {
	import net.wooga.uiengine.displaylistselector.ISpecificity;

	internal class Specificity implements ISpecificity {
		
		private static const SPECIFICITY_BASE:int = 60;

		private var _a:int;
		private var _b:int;
		private var _c:int;
		private var _d:int;
		private var _e:int;

		
		private var _numberValue:Number;
		
		
		public function toNumber():Number {
			return _numberValue;
		}

		public function isLessThan(other:ISpecificity):Boolean {
			return other is Specificity ? compare(other as Specificity) == -1 : this.toNumber() < other.toNumber();
		}

		public function isGreaterThan(other:ISpecificity):Boolean {
			return other is Specificity ? compare(other as Specificity) == 1 : this.toNumber() > other.toNumber();
		}

		public function isEqualTo(other:ISpecificity):Boolean {
			return other is Specificity ? compare(other as Specificity) == 0: this.toNumber() == other.toNumber();
		}


		private function compare(other:Specificity):int {
			return comparePosition(other, 'a') || comparePosition(other, 'b') || comparePosition(other, 'c') || comparePosition(other, 'd') || comparePosition(other, 'e');
		}

		private function comparePosition(other:Specificity, position:String):int {
			var here:int = this[position];
			var there:int = other[position];
			
			if(here < there) {
				return -1;
			}
			else if(here > there) {
				return 1;
			}

			return 0;
			
		}



		public function get a():int {
			return _a;
		}

		//if style is set from a manual style rule
		public function set a(value:int):void {
			_a = value;
			recalculateNumberValue();
		}

		public function get b():int {
			return _b;
		}

		//for id selectors
		public function set b(value:int):void {
			_b = value;
			recalculateNumberValue();
		}

		public function get c():int {
			return _c;
		}

		//class selectors, attributes selectors, and pseudo-classes in the selector
		public function set c(value:int):void {
			_c = value;
			recalculateNumberValue();
		}


		public function get d():int {
			return _d;
		}

		//type selectors and pseudo-elements in the selector
		public function set d(value:int):void {
			_d = value;
			recalculateNumberValue();
		}


		public function get e():int {
			return _e;
		}

		//is-A selectors
		public function set e(value:int):void {
			_e = value;
			recalculateNumberValue();
		}


		private function recalculateNumberValue():void {
			_numberValue = _a * Math.pow(SPECIFICITY_BASE, 4) + _b * Math.pow(SPECIFICITY_BASE, 3) + _c * Math.pow(SPECIFICITY_BASE, 2) + _d * Math.pow(SPECIFICITY_BASE, 1) +  _e;
		}
	}
}
