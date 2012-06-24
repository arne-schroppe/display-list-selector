package net.wooga.selectors.usagepatterns.implementations {

	import net.wooga.selectors.adaptermap.SelectorAdapterSource;
	import net.wooga.selectors.matching.MatcherTool;
	import net.wooga.selectors.parser.Parser;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.selectorstorage.SelectorTree;
	import net.wooga.selectors.tools.SpecificityComparator;
	import net.wooga.selectors.usagepatterns.*;

	public class SelectorPoolImpl implements SelectorPool {

		;

		private var _matcher:MatcherTool;
		private var _adapterSource:SelectorAdapterSource;
		private var _parser:Parser;

		private var _knownSelectors:SelectorTree = new SelectorTree();


		public function SelectorPoolImpl(parser:Parser, matcher:MatcherTool, adapterSource:SelectorAdapterSource) {
			_parser = parser;
			_matcher = matcher;
			_adapterSource = adapterSource;

		}


		public function addSelector(selectorString:String):void {
			var parsed:Vector.<SelectorImpl> = _parser.parse(selectorString);

			for each(var selector:SelectorImpl in parsed) {
				_knownSelectors.add(selector);
			}
		}


		public function getSelectorsMatchingObject(object:Object):Vector.<SelectorDescription> {
			return getPseudoElementSelectorsMatchingObject(object, null);
		}


		public function getPseudoElementSelectorsMatchingObject(object:Object, pseudoElement:String):Vector.<SelectorDescription> {

			var adapter:SelectorAdapter = getAdapterOrThrowException(object);
			var matches:Vector.<SelectorDescription> = new <SelectorDescription>[];

			var possibleMatches:Array = _knownSelectors.getPossibleMatchesFor(adapter, pseudoElement);

			var len:int = possibleMatches.length;
			for(var i:int = 0; i < len; ++i) {
				var selector:SelectorImpl = possibleMatches[i] as SelectorImpl;

				trace("----");
				trace("----");
				trace("Testing " + selector.selectorGroupString);
				if (_matcher.isObjectMatching(adapter, selector.matcherSequences)) {
					//TODO (arneschroppe 3/18/12) use an object pool here, so we don't have the overhead of creating objects all the time. They're flyweight's anyway
					matches.push(selector);
				}
			}

			//TODO (arneschroppe 3/18/12) because of the comma-separator in strings, it might be possible that selectors get added several times. we should make the vector unique
			matches = matches.sort(SpecificityComparator.staticCompare);


			return matches as Vector.<SelectorDescription>;
		}


		private function getAdapterOrThrowException(object:Object):SelectorAdapter {
			var adapter:SelectorAdapter = _adapterSource.getSelectorAdapterForObject(object);
			if (!adapter) {
				throw new ArgumentError("No style adapter registered for object " + object);
			}
			return adapter;
		}
	}
}
