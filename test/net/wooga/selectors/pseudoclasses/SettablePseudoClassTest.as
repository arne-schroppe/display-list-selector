package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.throws;
	import org.hamcrest.object.equalTo;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;

	public class SettablePseudoClassTest {

		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();

		[Mock]
		public var subject:SelectorAdapter;

		private var _hover:PseudoClass;

		private static const PSEUDO_CLASS_NAME:String = "pseudo-class-name";

		[Before]
		public function setUp():void {
			_hover = new SettablePseudoClass(PSEUDO_CLASS_NAME);
		}


		[Test]
		public function should_match_hovered_elements():void {
			given(subject.hasPseudoClass(PSEUDO_CLASS_NAME)).willReturn(true);
			assertThat(_hover.isMatching(subject), equalTo(true));
		}


		[Test]
		public function should_not_match_elements_that_are_not_hovered():void {
			given(subject.hasPseudoClass(PSEUDO_CLASS_NAME)).willReturn(false);
			given(subject.hasPseudoClass("some_other_pseudoclass")).willReturn(true);
			assertThat(_hover.isMatching(subject), equalTo(false));
		}


		[Test]
		public function should_not_accept_arguments():void {

			assertThat(function ():void {
				_hover.setArguments(["test1"])
			}, throws(isA(ArgumentError)));

		}
	}
}
