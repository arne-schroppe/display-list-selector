package net.wooga.displaylistselector.parser {
	import net.wooga.displaylistselector.IExternalPropertySource;

	import org.flexunit.rules.IMethodRule;
	import org.mockito.integrations.flexunit4.MockitoRule;

	public class ParserTest {

		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();

		[Mock]
		public var propertySource:IExternalPropertySource;

		[Mock]
		public var pseudoClassProvider:IPseudoClassProvider;


		private var _parser:Parser;

		[Before]
		public function setUp():void {
			_parser = new Parser(propertySource, pseudoClassProvider, "idAttribute", "classAttribute");
		}

	}
}
