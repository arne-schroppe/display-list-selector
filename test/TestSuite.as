package {

	import net.wooga.displaylistselector.SelectorTest;
	import net.wooga.displaylistselector.input.ParserInputTest;
	import net.wooga.displaylistselector.matching.matchers.ChildSelectorMatcherTest;
	import net.wooga.displaylistselector.matching.matchers.PropertyFilterContainsMatcherTest;
	import net.wooga.displaylistselector.matching.matchers.PropertyFilterEqualsMatcherTest;
	import net.wooga.displaylistselector.matching.matchers.PseudoClassMatcherTest;
	import net.wooga.displaylistselector.matching.matchers.TypeNameMatcherTest;
	import net.wooga.displaylistselector.parser.SpecificityTest;
	import net.wooga.displaylistselector.pseudoclasses.ActiveTest;
	import net.wooga.displaylistselector.pseudoclasses.FirstChildTest;
	import net.wooga.displaylistselector.pseudoclasses.HoverTest;
	import net.wooga.displaylistselector.pseudoclasses.IsEmptyTest;
	import net.wooga.displaylistselector.pseudoclasses.LastChildTest;
	import net.wooga.displaylistselector.pseudoclasses.NthChildTest;
	import net.wooga.displaylistselector.pseudoclasses.NthLastChildTest;
	import net.wooga.displaylistselector.pseudoclasses.NthLastOfTypeTest;
	import net.wooga.displaylistselector.pseudoclasses.NthOfTypeTest;
	import net.wooga.displaylistselector.pseudoclasses.RootTest;
	import net.wooga.displaylistselector.pseudoclasses.nthchildren.NthParserTest;
	import net.wooga.displaylistselector.selectorstorage.SelectorStorageTest;

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
		public var specificityTest:SpecificityTest;

		public var selectorStorageTest:SelectorStorageTest;
		public var hoverTest:HoverTest;
		public var activeTest:ActiveTest;
		//public var parserTest:ParserTest;

	}
}
