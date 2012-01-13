package net.wooga.uiengine.displaylistselector.pseudoclasses.nthchildren {
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;

	public class NthParserTest {

		private var _parser:NthChildArgumentParser;

		[Before]
		public function setUp():void {
			_parser = new NthChildArgumentParser();
		}

		[Test]
		public function should_parse_single_number():void {

			var result:NthParserResult = _parser.parse("3");

			assertThat(result.a, equalTo(0));
			assertThat(result.b, equalTo(3));
		}


		[Test]
		public function should_parse_regular_form():void {

			var result:NthParserResult = _parser.parse("5n + 12");

			assertThat(result.a, equalTo(5));
			assertThat(result.b, equalTo(12));
		}



		[Test]
		public function should_parse_odd():void {

			var result:NthParserResult = _parser.parse(" odd ");

			assertThat(result.a, equalTo(2));
			assertThat(result.b, equalTo(1));
		}



		[Test]
		public function should_parse_even():void {

			var result:NthParserResult = _parser.parse(" even ");

			assertThat(result.a, equalTo(2));
			assertThat(result.b, equalTo(0));
		}


		[Test]
		public function should_parse_a_part_only():void {

			var result:NthParserResult = _parser.parse(" 99n ");

			assertThat(result.a, equalTo(99));
			assertThat(result.b, equalTo(0));
		}

		[Test]
		public function should_parse_a_part_without_number():void {

			var result:NthParserResult = _parser.parse(" n ");

			assertThat(result.a, equalTo(1));
			assertThat(result.b, equalTo(0));
		}

		[Test]
		public function should_parse_a_part_with_negative_number():void {

			var result:NthParserResult = _parser.parse(" -n ");

			assertThat(result.a, equalTo(-1));
			assertThat(result.b, equalTo(0));
		}


		[Test]
		public function should_parse_b_part_with_negative_number():void {

			var result:NthParserResult = _parser.parse(" -33 ");

			assertThat(result.a, equalTo(0));
			assertThat(result.b, equalTo(-33));
		}


		[Test]
		public function should_parse_a_part_with_negative_b():void {

			var result:NthParserResult = _parser.parse(" 12n - 49 ");

			assertThat(result.a, equalTo(12));
			assertThat(result.b, equalTo(-49));
		}

		[Test]
		public function should_parse_a_part_without_number_and_b_part():void {

			var result:NthParserResult = _parser.parse(" n + 23 ");

			assertThat(result.a, equalTo(1));
			assertThat(result.b, equalTo(23));
		}


		[Test]
		public function should_parse_negative_a_and_negative_b():void {

			var result:NthParserResult = _parser.parse(" -2n - 13 ");

			assertThat(result.a, equalTo(-2));
			assertThat(result.b, equalTo(-13));
		}



	}
}
