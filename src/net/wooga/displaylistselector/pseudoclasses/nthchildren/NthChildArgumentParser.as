package net.wooga.displaylistselector.pseudoclasses.nthchildren {
	import net.wooga.displaylistselector.parser.ParserError;
	import net.wooga.displaylistselector.tools.input.ParserInput;

	public class NthChildArgumentParser {

		private var _result:NthParserResult;
		private var _input:ParserInput;
		private var _sign:int = 1;
		private var _value:int = 0;

		public function parse(input:String):NthParserResult {

			_result = new NthParserResult();
			_input = new ParserInput(input);

			expression();

			return _result;

		}


		/*
			grammar:

			expression: S* content

			content: 'even' | 'odd' | regularForm

		 	regularForm: aPart bPart

			aPart: sign integer 'n'

			bPart: S* sign S* integer


		*/


		private function expression():void {
			whitespace();
			content();
		}


		private function content():void {
			if(_input.isNext("even")) {
				_input.consume(4);
				_result.a = 2;
				_result.b = 0;
			}
			else if(_input.isNext("odd")) {
				_input.consume(3);
				_result.a = 2;
				_result.b = 1;
			}
			else {
				regularForm();
			}
		}


		private function regularForm():void {

			var matchedOne:Boolean = false;
			if(_input.isNextMatching(/[\-\+]?[0-9]*n/)) {
				aPart();
				matchedOne = true;
			}

			whitespace();

			if(_input.isNextMatching(/[\-\+]?\s*[0-9]+/)) {
				bPart();
				matchedOne = true;
			}
			
			if(!matchedOne) {
				throw new ParserError("Neither a nor b part given");
			}
		}


		private function aPart():void {

			sign();

			_value = 1;
			if(_input.isNextMatching(/[0-9]+/)) {
				integer();
			}


			_result.a = _sign * _value;

			if(!_input.isNext("n")) {
				throw new ParserError("n expected");
			}

			_input.consume(1);

		}


		private function integer():void {
			var result:String = _input.consumeRegex(/[0-9]+/);
			_value = parseInt(result);
		}


		private function sign():void {
			_sign = 1;
			if(_input.isNext("+")) {
				_input.consume(1);
			}
			else if(_input.isNext("-")) {
				_sign = -1;
				_input.consume(1);
			}
		}


		private function bPart():void {

			whitespace();
			sign();
			whitespace();
			integer();
			_result.b = _sign * _value;

		}


		private function whitespace():void {
			_input.consumeRegex(/\s*/);
		}

		
	}
}
