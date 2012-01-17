package net.wooga.uiengine.displaylistselector.input {
	import net.wooga.uiengine.displaylistselector.parser.ParserError;

	public class ParserInput {


		private var _originalContent:String;

		private var _remainingContent:String;
		private var _consumedAmount:int = 0;

		public static const NOT_FOUND:String = null;

		public function ParserInput(content:String) {
			_originalContent = content;
			updateRemainingContent();
		}


		public function get remainingContent():String {
			return _remainingContent;
		}

		public function consume(amount:int):void {
			_consumedAmount += amount;
			updateRemainingContent();
		}


		private function updateRemainingContent():void {
			_remainingContent = _originalContent.substr(_consumedAmount);
		}


		public function get hasContentLeft():Boolean {
			return _consumedAmount < _originalContent.length;
		}


		public function isNext(value:String):Boolean {
			return _remainingContent.substr(0, value.length) == value;
		}


		public function consumeString(value:String):void {
			if (!isNext(value)) {
				throwExpectationError(value);
			}

			consume(value.length);
		}


		public function isNextMatching(expression:RegExp):Boolean {
			var result:Object = expression.exec(_remainingContent);
			if (result == null || result.index != 0) {
				return false;
			}

			return true;
		}


		public function consumeRegex(expression:RegExp):String {
			var result:String = matchAndReturnNext(expression);
			if (result == NOT_FOUND) {
				throwExpectationError(expression.toString());
			}

			consume(result.length);
			return result;
		}

//
//		public function consumeOneOf(values:Array):String {
//			var expression:RegExp = new RegExp(values.join("|"));
//			var result:String = matchAndReturnNext(expression);
//			if (result == NOT_FOUND) {
//				throwExpectationError("one of [ " + values.join(", ") + " ]");
//			}
//
//			consume(result.length);
//			return result;
//		}
//


		private function matchAndReturnNext(expression:RegExp):String {
			var result:Object = expression.exec(_remainingContent);
			if (result == null || result.index != 0) {
				return NOT_FOUND;
			}

			return result[0] as String;
		}


		private function throwExpectationError(value:String):void {
			throw new ParserError("Expected " + value + " at position " + _consumedAmount + " in \"" + _originalContent + "\" \n " + pointToCurrentPosition());
		}


		private function pointToCurrentPosition():String {
			return _originalContent.substr(0, _consumedAmount) + " >>>" + _originalContent.substr(_consumedAmount);
		}
	}
}
