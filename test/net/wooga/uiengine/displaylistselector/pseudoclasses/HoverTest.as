package net.wooga.uiengine.displaylistselector.pseudoclasses {
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.throws;
	import org.hamcrest.object.equalTo;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;

	public class HoverTest {

		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();

		[Mock]
		public var subject:ISelectorAdapter;

		private var _hover:IPseudoClass;

		[Before]
		public function setUp():void {
			_hover = new Hover();
		}


		[Test]
		public function should_match_hovered_elements():void {
			given(subject.isHovered()).willReturn(true);
			assertThat(_hover.isMatching(subject), equalTo(true));
		}


		[Test]
		public function should_not_match_elements_that_are_not_hovered():void {
			given(subject.isHovered()).willReturn(false);
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
