package net.wooga.selectors.input {

	import net.wooga.selectors.parser.ParserError;
	import net.wooga.selectors.tools.input.ParserInput;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.not;
	import org.hamcrest.core.throws;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;

	public class ParserInputTest {


		private var _parserInput:ParserInput;

		[Test]
		public function should_consume_arbitraru_amount_of_tokens():void {
			_parserInput = new ParserInput("1234");

			_parserInput.consume(2);

			assertThat(_parserInput.remainingContent, equalTo("34"));
		}


		[Test]
		public function should_indicate_whether_there_is_content_left():void {
			_parserInput = new ParserInput("----");

			_parserInput.consume(2);
			assertThat(_parserInput.hasContentLeft, equalTo(true));

			_parserInput.consume(2);
			assertThat(_parserInput.hasContentLeft, equalTo(false));
		}


		[Test]
		public function should_peek_into_next_token():void {
			_parserInput = new ParserInput("abcde");

			assertThat(_parserInput.isNext("b"), equalTo(false));
			assertThat(_parserInput.isNext("c"), equalTo(false));
			assertThat(_parserInput.isNext("d"), equalTo(false));
			assertThat(_parserInput.isNext("e"), equalTo(false));
			assertThat(_parserInput.isNext("a"), equalTo(true));
		}


		[Test]
		public function should_consume_a_string():void {

			_parserInput = new ParserInput("token1234");
			_parserInput.consumeString("token");
			assertThat(_parserInput.remainingContent, equalTo("1234"));
		}


		[Test]
		public function should_throw_exception_if_string_can_not_be_consumed():void {
			_parserInput = new ParserInput("invalid1234");

			assertThat(function ():void {
				_parserInput.consumeString("token");
			}, throws(instanceOf(ParserError)));


			assertThat(_parserInput.remainingContent, equalTo("invalid1234"));
		}


		[Test]
		public function should_match_regex():void {
			_parserInput = new ParserInput("some-complex-token 1234");

			assertThat(_parserInput.isNextMatching(/[1234]+/), equalTo(false));
			assertThat(_parserInput.isNextMatching(/[a-z\-]+/), equalTo(true));
		}


		[Test]
		public function should_consume_regex():void {
			_parserInput = new ParserInput("some-complex-token 1234");

			var result:String = _parserInput.consumeRegex(/[a-z\-]+/);
			assertThat(result, equalTo("some-complex-token"));
			assertThat(_parserInput.remainingContent, equalTo(" 1234"));
		}


		[Test]
		public function should_throw_exception_if_regex_cannot_be_consumed():void {

			_parserInput = new ParserInput("some-complex-token 1234");

			assertThat(function ():void {
				_parserInput.consumeRegex(/[0-9]+/);
			}, throws(instanceOf(ParserError)));

			assertThat(_parserInput.remainingContent, equalTo("some-complex-token 1234"));
		}

		[Test]
		public function should_be_able_to_handle_isnext_if_everything_is_consumed():void {
			_parserInput = new ParserInput("1234567");
			_parserInput.consume(7);

			var result:Boolean;

			assertThat(function ():void {
				result = _parserInput.isNext("XYZ");
			}, not(throws(isA(Error))));

			assertThat(result, equalTo(false));
		}
	}
}
