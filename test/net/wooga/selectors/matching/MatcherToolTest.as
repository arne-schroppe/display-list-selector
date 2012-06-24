package net.wooga.selectors.matching {

	import net.wooga.displaytreebuilder.DisplayTree;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;
	import net.wooga.fixtures.tools.ContextViewBasedTest;
	import net.wooga.selectors.adaptermap.SelectorAdapterMap;
	import net.wooga.selectors.displaylist.DisplayObjectSelectorAdapter;
	import net.wooga.selectors.matching.combinators.Combinator;
	import net.wooga.selectors.matching.combinators.CombinatorType;
	import net.wooga.selectors.matching.combinators.MatcherFamily;
	import net.wooga.selectors.matching.matchers.implementations.IdMatcher;
	import net.wooga.selectors.matching.matchers.implementations.PseudoClassMatcher;
	import net.wooga.selectors.matching.matchers.implementations.TypeNameMatcher;
	import net.wooga.selectors.matching.matchersequence.MatcherSequence;
	import net.wooga.selectors.matching.matchersequence.MatcherSequenceImpl;
	import net.wooga.selectors.pseudoclasses.OnlyChild;
	import net.wooga.selectors.pseudoclasses.SettablePseudoClass;
	import net.wooga.selectors.pseudoclasses.names.PseudoClassName;

	import org.flexunit.asserts.fail;
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

		//TODO (arneschroppe 07/06/2012) what about hover, etc ??
		//TODO (arneschroppe 07/06/2012) solution: invalidate cache when hover changes (maybe selectively, if cache is tree based. matchersequence could have volatile flag)
		//TODO (arneschroppe 08/06/2012) then what about name and css class? Maybe we can keep the cache for one frame or something like that?

		[Rule]
		public var mockitoRule:IMethodRule = new MockitoRule();

		public var testSpriteBMatcherArgs:Array = ["TestSpriteB"];
		[Mock(argsList="testSpriteBMatcherArgs")]
		public var testSpriteBMatcher:TypeNameMatcher;


		public var idMatcherArgs:Array = ["test-id"];
		[Mock(argsList="idMatcherArgs")]
		public var idMatcher:IdMatcher;

		public var onlyChildMatcherArgs:Array = [new OnlyChild()];
		[Mock(argsList="onlyChildMatcherArgs")]
		public var onlyChildMatcher:PseudoClassMatcher;

		public var hoverMatcherArgs:Array = [new SettablePseudoClass(PseudoClassName.HOVER)];
		[Mock(argsList="hoverMatcherArgs")]
		public var hoverMatcher:PseudoClassMatcher;

		public var testSpriteCMatcherArgs:Array = ["TestSpriteC"];
		[Mock(argsList="testSpriteCMatcherArgs")]
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



		[Test]
		public function should_not_rematch_complex_elements():void {

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
			given(idMatcher.isMatching(eq(testSpriteBAdapter))).willReturn(true);
			given(onlyChildMatcher.isMatching(eq(testSpriteBAdapter))).willReturn(true);
			given(hoverMatcher.isMatching(eq(testSpriteBAdapter))).willReturn(true);
			var matcherSequence1:MatcherSequenceImpl = new MatcherSequenceImpl();
			matcherSequence1.parentCombinator = null;
			matcherSequence1.elementMatchers.push(testSpriteBMatcher);
			matcherSequence1.elementMatchers.push(idMatcher);
			matcherSequence1.elementMatchers.push(onlyChildMatcher);
			matcherSequence1.elementMatchers.push(hoverMatcher);


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
			verify(times(1)).that(idMatcher.isMatching(any()));
			verify(times(1)).that(onlyChildMatcher.isMatching(any()));
			verify(times(1)).that(hoverMatcher.isMatching(any()));

		}



		[Test]
		public function should_not_rematch_failed_matches():void {

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

			//BMatcher doesn't match
			given(testSpriteBMatcher.isMatching(eq(testSpriteBAdapter))).willReturn(false);
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
			assertThat(_matcherTool.isObjectMatching(testSpriteC1Adapter, matcherSequences), equalTo(false));
			assertThat(_matcherTool.isObjectMatching(testSpriteC2Adapter, matcherSequences), equalTo(false));
			assertThat(_matcherTool.isObjectMatching(testSpriteC3Adapter, matcherSequences), equalTo(false));


			//Check that the matcher for TestSpriteB is only checked once!
			verify(times(1)).that(testSpriteBMatcher.isMatching(any()));

		}



		[Ignore]
		[Test]
		public function should_invalidate_cached_matches_when_removing_object_from_stage():void {

			//create same setup as in last test

			//match all TestSpriteC's

			//remove TestSpriteB from context view

			//add it again

			//match TestSpriteC's again

			//verify that the TestSpriteBMatcher was called exactly twice


			fail("implement me");
		}


		[Test]
		public function should_invalidate_cached_matches_when_pseudoclass_changes():void {

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




			given(testSpriteBMatcher.isMatching(eq(testSpriteBAdapter))).willReturn(true);
			given(hoverMatcher.isMatching(eq(testSpriteBAdapter))).willReturn(true);
			var matcherSequence1:MatcherSequenceImpl = new MatcherSequenceImpl();
			matcherSequence1.parentCombinator = null;
			matcherSequence1.elementMatchers.push(testSpriteBMatcher);
			matcherSequence1.elementMatchers.push(hoverMatcher);


			given(testSpriteCMatcher.isMatching(eq(testSpriteC1Adapter))).willReturn(true);
			given(testSpriteCMatcher.isMatching(eq(testSpriteC2Adapter))).willReturn(true);
			given(testSpriteCMatcher.isMatching(eq(testSpriteC3Adapter))).willReturn(true);
			var matcherSequence2:MatcherSequenceImpl = new MatcherSequenceImpl();
			matcherSequence2.parentCombinator = new Combinator(MatcherFamily.ANCESTOR_COMBINATOR, CombinatorType.CHILD);
			matcherSequence2.elementMatchers.push(testSpriteCMatcher);

			var matcherSequences:Vector.<MatcherSequence> = new <MatcherSequence>[matcherSequence1, matcherSequence2];



			assertThat(_matcherTool.isObjectMatching(testSpriteC1Adapter, matcherSequences), equalTo(true));
			assertThat(_matcherTool.isObjectMatching(testSpriteC2Adapter, matcherSequences), equalTo(true));
			assertThat(_matcherTool.isObjectMatching(testSpriteC3Adapter, matcherSequences), equalTo(true));


			testSpriteBAdapter.addPseudoClass(PseudoClassName.HOVER);

			//Due to a bug in Mockito, we can't change the return value we gave earlier. that's why hoverMatcher already succeeds in the first call (even though it should return false) and is not reset to return true here. (asc 08/07/2012)
			//given(hoverMatcher.isMatching(eq(testSpriteBAdapter))).willReturn(true);

			assertThat(_matcherTool.isObjectMatching(testSpriteC1Adapter, matcherSequences), equalTo(true));
			assertThat(_matcherTool.isObjectMatching(testSpriteC2Adapter, matcherSequences), equalTo(true));
			assertThat(_matcherTool.isObjectMatching(testSpriteC3Adapter, matcherSequences), equalTo(true));


			//Matcher is checked twice because of cache invalidation
			verify(times(2)).that(testSpriteBMatcher.isMatching(any()));
			verify(times(2)).that(hoverMatcher.isMatching(any()));
		}



		[Test]
		public function should_invalidate_cached_matches_when_css_id_changes():void {

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




			given(testSpriteBMatcher.isMatching(eq(testSpriteBAdapter))).willReturn(true);
			given(hoverMatcher.isMatching(eq(testSpriteBAdapter))).willReturn(true);
			var matcherSequence1:MatcherSequenceImpl = new MatcherSequenceImpl();
			matcherSequence1.parentCombinator = null;
			matcherSequence1.elementMatchers.push(testSpriteBMatcher);
			matcherSequence1.elementMatchers.push(hoverMatcher);


			given(testSpriteCMatcher.isMatching(eq(testSpriteC1Adapter))).willReturn(true);
			given(testSpriteCMatcher.isMatching(eq(testSpriteC2Adapter))).willReturn(true);
			given(testSpriteCMatcher.isMatching(eq(testSpriteC3Adapter))).willReturn(true);
			var matcherSequence2:MatcherSequenceImpl = new MatcherSequenceImpl();
			matcherSequence2.parentCombinator = new Combinator(MatcherFamily.ANCESTOR_COMBINATOR, CombinatorType.CHILD);
			matcherSequence2.elementMatchers.push(testSpriteCMatcher);

			var matcherSequences:Vector.<MatcherSequence> = new <MatcherSequence>[matcherSequence1, matcherSequence2];



			assertThat(_matcherTool.isObjectMatching(testSpriteC1Adapter, matcherSequences), equalTo(true));
			assertThat(_matcherTool.isObjectMatching(testSpriteC2Adapter, matcherSequences), equalTo(true));
			assertThat(_matcherTool.isObjectMatching(testSpriteC3Adapter, matcherSequences), equalTo(true));


			testSpriteBAdapter.setId("test123");

			//Due to a bug in Mockito, we can't change the return value we gave earlier. that's why hoverMatcher already succeeds in the first call (even though it should return false) and is not reset to return true here. (asc 08/07/2012)
			//given(hoverMatcher.isMatching(eq(testSpriteBAdapter))).willReturn(true);

			assertThat(_matcherTool.isObjectMatching(testSpriteC1Adapter, matcherSequences), equalTo(true));
			assertThat(_matcherTool.isObjectMatching(testSpriteC2Adapter, matcherSequences), equalTo(true));
			assertThat(_matcherTool.isObjectMatching(testSpriteC3Adapter, matcherSequences), equalTo(true));


			//Matcher is checked twice because of cache invalidation
			verify(times(2)).that(testSpriteBMatcher.isMatching(any()));
			verify(times(2)).that(hoverMatcher.isMatching(any()));
		}




		[Test]
		public function should_invalidate_cached_matches_when_css_classes_change():void {

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




			given(testSpriteBMatcher.isMatching(eq(testSpriteBAdapter))).willReturn(true);
			given(hoverMatcher.isMatching(eq(testSpriteBAdapter))).willReturn(true);
			var matcherSequence1:MatcherSequenceImpl = new MatcherSequenceImpl();
			matcherSequence1.parentCombinator = null;
			matcherSequence1.elementMatchers.push(testSpriteBMatcher);
			matcherSequence1.elementMatchers.push(hoverMatcher);


			given(testSpriteCMatcher.isMatching(eq(testSpriteC1Adapter))).willReturn(true);
			given(testSpriteCMatcher.isMatching(eq(testSpriteC2Adapter))).willReturn(true);
			given(testSpriteCMatcher.isMatching(eq(testSpriteC3Adapter))).willReturn(true);
			var matcherSequence2:MatcherSequenceImpl = new MatcherSequenceImpl();
			matcherSequence2.parentCombinator = new Combinator(MatcherFamily.ANCESTOR_COMBINATOR, CombinatorType.CHILD);
			matcherSequence2.elementMatchers.push(testSpriteCMatcher);

			var matcherSequences:Vector.<MatcherSequence> = new <MatcherSequence>[matcherSequence1, matcherSequence2];



			assertThat(_matcherTool.isObjectMatching(testSpriteC1Adapter, matcherSequences), equalTo(true));
			assertThat(_matcherTool.isObjectMatching(testSpriteC2Adapter, matcherSequences), equalTo(true));
			assertThat(_matcherTool.isObjectMatching(testSpriteC3Adapter, matcherSequences), equalTo(true));


			testSpriteBAdapter.addClass("someTestClass");

			//Due to a bug in Mockito, we can't change the return value we gave earlier. that's why hoverMatcher already succeeds in the first call (even though it should return false) and is not reset to return true here. (asc 08/07/2012)
			//given(hoverMatcher.isMatching(eq(testSpriteBAdapter))).willReturn(true);

			assertThat(_matcherTool.isObjectMatching(testSpriteC1Adapter, matcherSequences), equalTo(true));
			assertThat(_matcherTool.isObjectMatching(testSpriteC2Adapter, matcherSequences), equalTo(true));
			assertThat(_matcherTool.isObjectMatching(testSpriteC3Adapter, matcherSequences), equalTo(true));


			//Matcher is checked twice because of cache invalidation
			verify(times(2)).that(testSpriteBMatcher.isMatching(any()));
			verify(times(2)).that(hoverMatcher.isMatching(any()));
		}
	}
}
