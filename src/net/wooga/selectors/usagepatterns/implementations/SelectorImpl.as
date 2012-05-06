package net.wooga.selectors.usagepatterns.implementations {

	import net.wooga.selectors.adaptermap.SelectorAdapterSource;
	import net.wooga.selectors.matching.MatcherTool;
	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.matching.matchersequence.MatcherSequence;
	import net.wooga.selectors.namespace.selector_internal;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.usagepatterns.*;

	use namespace selector_internal;

	public class SelectorImpl extends SelectorDescriptionImpl implements Selector {

		private var _adapterSource:SelectorAdapterSource;
		private var _matcherTool:MatcherTool;
		private var _matcherSequences:Vector.<MatcherSequence> = new <MatcherSequence>[];


		public function isMatching(object:Object):Boolean {
			var adapter:SelectorAdapter = _adapterSource.getSelectorAdapterForObject(object);
			if(!adapter) {
				throw new ArgumentError("No selector adapter registered for object " + object);
			}

			return _matcherTool.isObjectMatching(adapter, _matcherSequences);
		}



		selector_internal function set adapterMap(value:SelectorAdapterSource):void {
			_adapterSource = value;
		}

		selector_internal function set matcherTool(value:MatcherTool):void {
			_matcherTool = value;
		}


		selector_internal function set matcherSequences(value:Vector.<MatcherSequence>):void {
			_matcherSequences = value;
		}

		selector_internal function get matcherSequences():Vector.<MatcherSequence> {
			return _matcherSequences;
		}


	}
}
