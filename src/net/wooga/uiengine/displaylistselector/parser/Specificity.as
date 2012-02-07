package net.wooga.uiengine.displaylistselector.parser {
	import net.wooga.uiengine.displaylistselector.ISpecificity;

	internal class Specificity implements ISpecificity {
		
		private static const SPECIFICITY_BASE:int = 60;


		private var _digits:Vector.<int> = new Vector.<int>(5, true);
		

		
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
			return compareFromPosition(other, _digits.length-1);
		}


		private function compareFromPosition(other:Specificity, position:int):int {
			if(position < 0) {
				return 0;
			}

			return comparePosition(other, position) || compareFromPosition(other, position - 1);
		}

		private function comparePosition(other:Specificity, position:int):int {
			var here:int = this._digits[position];
			var there:int = other._digits[position];
			
			if(here < there) {
				return -1;
			}
			else if(here > there) {
				return 1;
			}

			return 0;
			
		}



		public function get a():int {
			return _digits[4];
		}

		//if style is set from a manual style rule
		public function set a(value:int):void {
			_digits[4] = value;
			recalculateNumberValue();
		}

		public function get b():int {
			return _digits[3];
		}

		//for id selectors
		public function set b(value:int):void {
			_digits[3] = value;
			recalculateNumberValue();
		}

		public function get c():int {
			return _digits[2];
		}

		//class selectors, attributes selectors, and pseudo-classes in the selector
		public function set c(value:int):void {
			_digits[2] = value;
			recalculateNumberValue();
		}


		public function get d():int {
			return _digits[1];
		}

		//type selectors and pseudo-elements in the selector
		public function set d(value:int):void {
			_digits[1] = value;
			recalculateNumberValue();
		}


		public function get e():int {
			return _digits[0];
		}

		//is-A selectors
		public function set e(value:int):void {
			_digits[0] = value;
			recalculateNumberValue();
		}


		private function recalculateNumberValue():void {
			
			var result:Number = 0;
			for(var position:int = 0; position < _digits.length; ++position) {
				result += _digits[position] * Math.pow(SPECIFICITY_BASE, position)
			}

			_numberValue = result;
		}
	}
}
