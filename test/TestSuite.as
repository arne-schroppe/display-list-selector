package {

	import net.wooga.selectors.SelectorFactoryTest;
	import net.wooga.selectors.input.ParserInputTest;
	import net.wooga.selectors.matching.matchers.ChildSelectorMatcherTest;
	import net.wooga.selectors.matching.matchers.PropertyFilterContainsMatcherTest;
	import net.wooga.selectors.matching.matchers.PropertyFilterEqualsMatcherTest;
	import net.wooga.selectors.matching.matchers.PseudoClassMatcherTest;
	import net.wooga.selectors.matching.matchers.TypeNameMatcherTest;
	import net.wooga.selectors.parser.SpecificityTest;
	import net.wooga.selectors.pseudoclasses.ActiveTest;
	import net.wooga.selectors.pseudoclasses.FirstChildTest;
	import net.wooga.selectors.pseudoclasses.HoverTest;
	import net.wooga.selectors.pseudoclasses.IsEmptyTest;
	import net.wooga.selectors.pseudoclasses.LastChildTest;
	import net.wooga.selectors.pseudoclasses.NthChildTest;
	import net.wooga.selectors.pseudoclasses.NthLastChildTest;
	import net.wooga.selectors.pseudoclasses.NthLastOfTypeTest;
	import net.wooga.selectors.pseudoclasses.NthOfTypeTest;
	import net.wooga.selectors.pseudoclasses.RootTest;
	import net.wooga.selectors.pseudoclasses.nthchildren.NthParserTest;
	import net.wooga.selectors.selectorstorage.SelectorStorageTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class TestSuite {

		public var displayListSelectorTest:SelectorFactoryTest;

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

	}
}
