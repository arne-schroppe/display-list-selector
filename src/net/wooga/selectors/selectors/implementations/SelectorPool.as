package net.wooga.selectors.selectors.implementations {

	import net.wooga.selectors.adaptermap.ISelectorAdapterSource;
	import net.wooga.selectors.matching.MatcherTool;
	import net.wooga.selectors.namespace.selector_internal;
	import net.wooga.selectors.parser.Parser;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;
	import net.wooga.selectors.selectorstorage.SelectorTree;
	import net.wooga.selectors.tools.SpecificityComparator;
	import net.wooga.selectors.selectors.*;

	public class SelectorPool implements ISelectorPool {

		use namespace selector_internal;

		private var _matcher:MatcherTool;
		private var _adapterSource:ISelectorAdapterSource;
		private var _parser:Parser;

		private var _knownSelectors:SelectorTree = new SelectorTree();


		public function SelectorPool(parser:Parser, matcher:MatcherTool, adapterSource:ISelectorAdapterSource) {
			_parser = parser;
			_matcher = matcher;
			_adapterSource = adapterSource;

		}


		public function addSelector(selectorString:String):void {
			var parsed:Vector.<Selector> = _parser.parse(selectorString);

			for each(var selector:Selector in parsed) {
				_knownSelectors.add(selector);
			}
		}


		public function getSelectorsMatchingObject(object:Object):Vector.<ISelector> {
			return getPseudoElementSelectorsMatchingObject(object, null);
		}

//TODO (asc 25/6/13) do these selectors have all their dependencies?
		public function getPseudoElementSelectorsMatchingObject(object:Object, pseudoElement:String):Vector.<ISelector> {
			var adapter:ISelectorAdapter = getAdapterOrThrowException(object);
			var matches:Vector.<ISelector> = new <ISelector>[];

			var possibleMatches:Array = _knownSelectors.getPossibleMatchesFor(adapter, pseudoElement);

			var len:int = possibleMatches.length;
			for(var i:int = 0; i < len; ++i) {
				var selector:Selector = possibleMatches[i] as Selector;
				if (_matcher.isObjectMatching(adapter, selector.matchers)) {
					//TODO (arneschroppe 3/18/12) use an object pool here, so we don't have the overhead of creating objects all the time. They're flyweight's anyway
					matches.push(selector);
				}
			}

			//TODO (arneschroppe 3/18/12) because of the comma-separator in strings, it might be possible that selectors get added several times. we should make the vector unique
			matches = matches.sort(SpecificityComparator.staticCompare);


			return matches as Vector.<ISelector>;
		}


		private function getAdapterOrThrowException(object:Object):ISelectorAdapter {
			var adapter:ISelectorAdapter = _adapterSource.getSelectorAdapterForObject(object);
			if (!adapter) {
				throw new ArgumentError("No style adapter registered for object " + object);
			}
			return adapter;
		}
	}
}
