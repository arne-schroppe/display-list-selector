package net.wooga.selectors.matching {

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.tools.ContextViewBasedTest;
	import net.wooga.selectors.adaptermap.SelectorAdapterMap;
	import net.wooga.selectors.displaylist.DisplayObjectSelectorAdapter;
	import net.wooga.selectors.matching.combinators.Combinator;
	import net.wooga.selectors.matching.combinators.CombinatorType;
	import net.wooga.selectors.matching.combinators.MatcherFamily;
	import net.wooga.selectors.matching.matchers.implementations.TypeNameMatcher;
	import net.wooga.selectors.matching.matchersequence.MatcherSequence;
	import net.wooga.selectors.matching.matchersequence.MatcherSequenceImpl;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	import org.flexunit.rules.IMethodRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.mockito.integrations.any;
	import org.mockito.integrations.eq;
	import org.mockito.integrations.flexunit4.MockitoRule;
	import org.mockito.integrations.given;
	import org.mockito.integrations.times;
	import org.mockito.integrations.verify;

	public class MatcherToolTest extends ContextViewBasedTest {

		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();

		public var matcherArgs:Array = ["TestSpriteB"];
		public var matcherArgs2:Array = ["TestSpriteC"];

		[Mock(argsList="matcherArgs")]
		public var testSpriteBMatcher:TypeNameMatcher;

		[Mock(argsList="matcherArgs2")]
		public var testSpriteCMatcher:TypeNameMatcher;


		private var _matcherTool:MatcherTool;

		private var _selectorAdapterMap:SelectorAdapterMap



		[Before]
		override public function setUp():void {
			super.setUp();
			_selectorAdapterMap = new SelectorAdapterMap();
			_matcherTool = new MatcherTool(contextView, _selectorAdapterMap);
		}


		[Test]
		public function should_not_rematch_matched_elements():void {

			var displayTree:DisplayTree = new DisplayTree();


			var instances:Array = [];
			displayTree.uses(contextView).containing
					.a(TestSpriteB).whichWillBeStoredIn(instances).containing
						.a(TestSpriteC).whichWillBeStoredIn(instances)
						.a(TestSpriteC).whichWillBeStoredIn(instances)
						.a(TestSpriteC).whichWillBeStoredIn(instances)
					.end
				.end.finish()

			//create and save adapters for all these objects

			var testSpriteBAdapter:DisplayObjectSelectorAdapter = new DisplayObjectSelectorAdapter();
			_selectorAdapterMap.setAdapterForObject(instances[0], testSpriteBAdapter);
			testSpriteBAdapter.register(instances[0]);

			var testSpriteC1Adapter:DisplayObjectSelectorAdapter = new DisplayObjectSelectorAdapter();
			_selectorAdapterMap.setAdapterForObject(instances[1], testSpriteC1Adapter);
			testSpriteC1Adapter.register(instances[1]);

			var testSpriteC2Adapter:DisplayObjectSelectorAdapter = new DisplayObjectSelectorAdapter();
			_selectorAdapterMap.setAdapterForObject(instances[2], testSpriteC2Adapter);
			testSpriteC2Adapter.register(instances[2]);

			var testSpriteC3Adapter:DisplayObjectSelectorAdapter = new DisplayObjectSelectorAdapter();
			_selectorAdapterMap.setAdapterForObject(instances[3], testSpriteC3Adapter);
			testSpriteC3Adapter.register(instances[3]);

			//create mocked matchers for the selector TestSpriteB > TestSpriteC and combine these to MatcherSequences

			given(testSpriteBMatcher.isMatching(eq(testSpriteBAdapter))).willReturn(true);
			var matcherSequence1:MatcherSequenceImpl = new MatcherSequenceImpl();
			matcherSequence1.parentCombinator = null;
			matcherSequence1.elementMatchers.push(testSpriteBMatcher);


			given(testSpriteCMatcher.isMatching(eq(testSpriteC1Adapter))).willReturn(true);
			given(testSpriteCMatcher.isMatching(eq(testSpriteC2Adapter))).willReturn(true);
			given(testSpriteCMatcher.isMatching(eq(testSpriteC3Adapter))).willReturn(true);
			var matcherSequence2:MatcherSequenceImpl = new MatcherSequenceImpl();
			matcherSequence2.parentCombinator = new Combinator(MatcherFamily.ANCESTOR_COMBINATOR, CombinatorType.CHILD);
			matcherSequence2.elementMatchers.push(testSpriteCMatcher);

			var matcherSequences:Vector.<MatcherSequence> = new <MatcherSequence>[matcherSequence1, matcherSequence2];


			//Sanity check
			assertThat(_matcherTool.isObjectMatching(testSpriteC1Adapter, matcherSequences), equalTo(true));
			assertThat(_matcherTool.isObjectMatching(testSpriteC2Adapter, matcherSequences), equalTo(true));
			assertThat(_matcherTool.isObjectMatching(testSpriteC3Adapter, matcherSequences), equalTo(true));


			//Check that the matcher for TestSpriteB is only checked once!
			verify(times(1)).that(testSpriteBMatcher.isMatching(any()));

		}
	}
}
