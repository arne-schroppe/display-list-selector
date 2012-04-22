package net.wooga.selectors.parser {

	import net.wooga.selectors.specificity.Specificity;

	internal class SpecificityImpl implements Specificity {
		
		private static const NUMBER_OF_POSITIONS:int = 5;

		private var _digits:Vector.<int> = new Vector.<int>(NUMBER_OF_POSITIONS, true);


		public function get numberOfDigits():int {
			return NUMBER_OF_POSITIONS;
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
		}

		public function get idSelector():int {
			return _digits[3];
		}

		//for id selectors
		public function set idSelector(value:int):void {
			_digits[3] = value;
		}

		public function get classAndAttributeAndPseudoSelectors():int {
			return _digits[2];
		}

		//class selectors, attributes selectors, and pseudo-classes in the selector
		public function set classAndAttributeAndPseudoSelectors(value:int):void {
			_digits[2] = value;
		}


		public function get elementSelectorsAndPseudoElements():int {
			return _digits[1];
		}

		//type selectors and pseudo-elements in the selector
		public function set elementSelectorsAndPseudoElements(value:int):void {
			_digits[1] = value;
		}


		public function get isAPseudoClassSelectors():int {
			return _digits[0];
		}

		//is-A selectors
		public function set isAPseudoClassSelectors(value:int):void {
			_digits[0] = value;
		}



		public function toString():String {
			return "[Specificity " + _digits.join(".") + "]";
		}


	}
}
