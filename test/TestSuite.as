package {

	import net.wooga.selectors.SelectorFactoryTest;
	import net.wooga.selectors.displaylist.DisplayObjectSelectorAdapterTest;
	import net.wooga.selectors.input.ParserInputTest;
	import net.wooga.selectors.matching.MatcherToolTest;
	import net.wooga.selectors.matching.matchers.PseudoClassMatcherTest;
	import net.wooga.selectors.matching.matchers.TypeNameMatcherTest;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AbstractStringAttributeMatcherTest;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeBeginsWithMatcherTest;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeContainsMatcherTest;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeContainsSubstringMatcherTest;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeEndsWithMatcherTest;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeEqualsMatcherTest;
	import net.wooga.selectors.matching.matchers.implementations.attributes.AttributeExistsMatcherTest;
	import net.wooga.selectors.parser.ParserTest;
	import net.wooga.selectors.parser.SpecificityTest;
	import net.wooga.selectors.pseudoclasses.FirstChildTest;
	import net.wooga.selectors.pseudoclasses.FirstOfTypeTest;
	import net.wooga.selectors.pseudoclasses.IsATest;
	import net.wooga.selectors.pseudoclasses.IsEmptyTest;
	import net.wooga.selectors.pseudoclasses.LastChildTest;
	import net.wooga.selectors.pseudoclasses.LastOfTypeTest;
	import net.wooga.selectors.pseudoclasses.NthChildTest;
	import net.wooga.selectors.pseudoclasses.NthLastChildTest;
	import net.wooga.selectors.pseudoclasses.NthLastOfTypeTest;
	import net.wooga.selectors.pseudoclasses.NthOfTypeTest;
	import net.wooga.selectors.pseudoclasses.OnlyChildTest;
	import net.wooga.selectors.pseudoclasses.OnlyOfTypeTest;
	import net.wooga.selectors.pseudoclasses.RootTest;
	import net.wooga.selectors.pseudoclasses.SettablePseudoClassTest;
	import net.wooga.selectors.pseudoclasses.nthchildren.NthParserTest;
	import net.wooga.selectors.selectorstorage.SelectorTreeTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class TestSuite {

		public var displayListSelectorTest:SelectorFactoryTest;

		public var parserInputTest:ParserInputTest;
		public var classNameMatcherTest:TypeNameMatcherTest;
		public var attributeContainsMatcherTest:AttributeContainsMatcherTest;
		public var attributeEqualsMatcherTest:AttributeEqualsMatcherTest;
		public var attributeExistsMatcherTest:AttributeExistsMatcherTest;
		public var abstractStringAttributeMatcherTest:AbstractStringAttributeMatcherTest;
		public var attributeBeginsWithMatcherTest:AttributeBeginsWithMatcherTest;
		public var attributeEndsWithMatcherTest:AttributeEndsWithMatcherTest;
		public var attributeContainsSubstringMatcherTest:AttributeContainsSubstringMatcherTest;
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
		public var isATest:IsATest;
		public var parserTest:ParserTest;
		public var firstOfTypeTest:FirstOfTypeTest;
		public var lastOfTypeTest:LastOfTypeTest;
		
		public var onlyChildTest:OnlyChildTest;
		public var onlyOfTypeTest:OnlyOfTypeTest;


		public var selectorStorageTest:SelectorTreeTest;
		public var settablePseudoClassTest:SettablePseudoClassTest;

		public var displayObjectSelectorAdapterTest:DisplayObjectSelectorAdapterTest;

		public var matcherToolTest:MatcherToolTest;

	}
}
