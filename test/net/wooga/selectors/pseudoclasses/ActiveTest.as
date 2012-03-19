package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.core.throws;
	import org.hamcrest.object.equalTo;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;

	public class ActiveTest {

		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();

		[Mock]
		public var subject:SelectorAdapter;

		private var _active:PseudoClass;

		[Before]
		public function setUp():void {
			_active = new Active();
		}


		[Test]
		public function should_match_hovered_elements():void {
			given(subject.isActive()).willReturn(true);
			assertThat(_active.isMatching(subject), equalTo(true));
		}


		[Test]
		public function should_not_match_elements_that_are_not_hovered():void {
			given(subject.isActive()).willReturn(false);
			assertThat(_active.isMatching(subject), equalTo(false));
		}


		[Test]
		public function should_not_accept_arguments():void {

			assertThat(function ():void {
				_active.setArguments(["test1"])
			}, throws(isA(ArgumentError)));

		}
	}
}
