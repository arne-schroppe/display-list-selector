package net.wooga.selectors.parser {

	import net.wooga.selectors.IExternalPropertySource;

	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.flexunit4.MockitoRule;

	public class ParserTest {

		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();

		[Mock]
		public var propertySource:IExternalPropertySource;

		[Mock]
		public var pseudoClassProvider:PseudoClassProvider;


		private var _parser:Parser;

		[Before]
		public function setUp():void {
			_parser = new Parser(propertySource, pseudoClassProvider, "idAttribute", "classAttribute");
		}

	}
}
