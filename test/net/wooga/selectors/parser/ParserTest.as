package net.wooga.selectors.parser {

	import net.wooga.selectors.selectors.implementations.Selector;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.throws;
	import org.hamcrest.object.equalTo;

	public class ParserTest {


		private var _parser:Parser;

		[Before]
		public function setUp():void {
			_parser = new Parser(null, new NullPseudoClassProvider());
		}


		[Test]
		public function should_properly_extract_sub_selectors():void {

			var result:Vector.<Selector> = _parser.parse("Elem1[xyz='abc']:hover, a > B Elem2, *:active");

			assertThat(result.length, equalTo(3));
			assertThat(result[0].selectorString, equalTo("Elem1[xyz='abc']:hover"));
			assertThat(result[1].selectorString, equalTo("a > B Elem2"));
			assertThat(result[2].selectorString, equalTo("*:active"));

		}


		[Test]
		public function should_retain_original_selector_string():void {

			var result:Vector.<Selector> = _parser.parse("Elem1[xyz='abc']:hover, a > B Elem2, *:active");

			assertThat(result.length, equalTo(3));
			assertThat(result[0].selectorGroupString, equalTo("Elem1[xyz='abc']:hover, a > B Elem2, *:active"));
			assertThat(result[1].selectorGroupString, equalTo("Elem1[xyz='abc']:hover, a > B Elem2, *:active"));
			assertThat(result[2].selectorGroupString, equalTo("Elem1[xyz='abc']:hover, a > B Elem2, *:active"));

		}


		[Test]
		public function should_throw_error_if_pseudo_element_is_not_last_in_simple_selector():void {
			assertThat(function():void {
				_parser.parse("Element::pseudo-element#id");
			}, throws(isA(ParserError)));
		}


		[Test]
		public function should_throw_error_if_pseudo_element_is_not_last_in_sequence():void {
			assertThat(function():void {
				_parser.parse("Element::pseudo-element > #id");
			}, throws(isA(ParserError)));
		}

	}
}

import net.wooga.selectors.parser.IPseudoClassProvider;
import net.wooga.selectors.pseudoclasses.IPseudoClass;
import net.wooga.selectors.selectoradapter.ISelectorAdapter;

class NullPseudoClassProvider implements IPseudoClassProvider {


	public function hasPseudoClass(pseudoClassName:String):Boolean {
		return true;
	}

	public function getPseudoClass(pseudoClassName:String):IPseudoClass {
		return new NullPseudoClass();
	}
}


class NullPseudoClass implements IPseudoClass {

	public function setArguments(arguments:Array):void {
	}

	public function isMatching(subject:ISelectorAdapter):Boolean {
		return false;
	}
}
