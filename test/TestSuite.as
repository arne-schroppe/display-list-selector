package {

	import net.wooga.uiengine.displaylistselector.SelectorTest;
	import net.wooga.uiengine.displaylistselector.input.ParserInputTest;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.ChildSelectorMatcherTest;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.TypeNameMatcherTest;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.PropertyFilterContainsMatcherTest;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.PropertyFilterEqualsMatcherTest;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.PseudoClassMatcherTest;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.FirstChildTest;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.IsEmptyTest;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.LastChildTest;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthChildTest;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthLastChildTest;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthLastOfTypeTest;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthOfTypeTest;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.RootTest;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.nthchildren.NthParserTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class TestSuite {

		public var displayListSelectorTest:SelectorTest;

		public var parserInputTest:ParserInputTest;
		public var childSelectorMatcherTest:ChildSelectorMatcherTest;
		public var classNameMatcherTest:TypeNameMatcherTest;
		public var propertyFilterContainsMatcherTest:PropertyFilterContainsMatcherTest;
		public var propertyFilterEqualsMatcherTest:PropertyFilterEqualsMatcherTest;
		public var pseudoClassMatcherTest:PseudoClassMatcherTest;
		public var firstChildTest:FirstChildTest;
		public var lastChildTest:LastChildTest;
		public var isEmptyTest:IsEmptyTest;
		public var nthChildTest:NthChildTest;
		public var nthOfTypeTest:NthOfTypeTest;
		public var nthLastChildTest:NthLastChildTest;
		public var nthLastOfTypeTest:NthLastOfTypeTest;
		public var rootTest:RootTest;
		public var nthParserTest:NthParserTest;
		//public var parserTest:ParserTest;

	}
}
