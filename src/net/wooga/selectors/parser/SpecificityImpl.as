package net.wooga.selectors.parser {

	import net.wooga.selectors.specificity.Specificity;

	internal class SpecificityImpl implements Specificity {
		
		private static const SPECIFICITY_BASE:int = 60;
		private static const NUMBER_FOF_POSITIONS:int = 5;

		private var _digits:Vector.<int> = new Vector.<int>(NUMBER_FOF_POSITIONS, true);
		

		
		private var _numberValue:Number;
		
		
		public function toNumber():Number {
			return _numberValue;
		}

		public function get positions():int {
			return NUMBER_FOF_POSITIONS;
		}

		public function digitAtPosition(position:int):int {
			return _digits[position];
		}


		public function compare(other:Specificity):int {
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
			var there:int = other.digitAtPosition(position);
			
			if(here < there) {
				return -1;
			}
			else if(here > there) {
				return 1;
			}

			return 0;
			
		}



		public function get manualStyleRule():int {
			return _digits[4];
		}

		//if style is set from a manual style rule
		public function set manualStyleRule(value:int):void {
			_digits[4] = value;
			recalculateNumberValue();
		}

		public function get idSelector():int {
			return _digits[3];
		}

		//for id selectors
		public function set idSelector(value:int):void {
			_digits[3] = value;
			recalculateNumberValue();
		}

		public function get classAndAttributeAndPseudoSelectors():int {
			return _digits[2];
		}

		//class selectors, attributes selectors, and pseudo-classes in the selector
		public function set classAndAttributeAndPseudoSelectors(value:int):void {
			_digits[2] = value;
			recalculateNumberValue();
		}


		public function get elementSelectorsAndPseudoElements():int {
			return _digits[1];
		}

		//type selectors and pseudo-elements in the selector
		public function set elementSelectorsAndPseudoElements(value:int):void {
			_digits[1] = value;
			recalculateNumberValue();
		}


		public function get isAPseudoClassSelectors():int {
			return _digits[0];
		}

		//is-A selectors
		public function set isAPseudoClassSelectors(value:int):void {
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


		public function toString():String {
			return "[Specificity " + _digits.join(".") + "]";
		}


	}
}
