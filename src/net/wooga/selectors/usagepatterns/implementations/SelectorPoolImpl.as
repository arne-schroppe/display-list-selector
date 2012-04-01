package net.wooga.selectors.usagepatterns.implementations {

	import flash.utils.Dictionary;

	import net.wooga.selectors.matching.MatcherTool;
	import net.wooga.selectors.parser.Parser;
	import net.wooga.selectors.selector_internal;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.selectorstorage.SelectorTree;
	import net.wooga.selectors.tools.SpecificityComparator;
	import net.wooga.selectors.usagepatterns.*;

	public class SelectorPoolImpl implements SelectorPool {

		use namespace selector_internal;

		private var _matcher:MatcherTool;
		private var _objectToStyleAdapterMap:Dictionary;
		private var _parser:Parser;

		private var _knownSelectors:SelectorTree = new SelectorTree();


		public function SelectorPoolImpl(parser:Parser, matcher:MatcherTool, objectToStyleAdapterMap:Dictionary) {
			_parser = parser;
			_matcher = matcher;
			_objectToStyleAdapterMap = objectToStyleAdapterMap;

		}


		public function addSelector(selectorString:String):void {
			var parsed:Vector.<SelectorImpl> = _parser.parse(selectorString);

			for each(var selector:SelectorImpl in parsed) {
				_knownSelectors.add(selector);
			}
		}


		public function getSelectorsMatchingObject(object:Object):Vector.<SelectorDescription> {
			var adapter:SelectorAdapter = _objectToStyleAdapterMap[object] as SelectorAdapter;
			if(!adapter) {
				throw new ArgumentError("No style adapter registered for object " + object);
			}

			var matches:Vector.<SelectorDescription> = new <SelectorDescription>[];

			var possibleMatches:Array = _knownSelectors.getPossibleMatchesFor(adapter);

			var len:int = possibleMatches.length;
			for(var i:int = 0; i < len; ++i) {
				var selector:SelectorImpl = possibleMatches[i] as SelectorImpl;
				if (_matcher.isObjectMatching(adapter, selector.matchers)) {
					//TODO (arneschroppe 3/18/12) use an object pool here, so we don't have the overhead of creating objects all the time. They're flyweight's anyway
					matches.push(selector);
				}
			}

			//TODO (arneschroppe 3/18/12) because of the comma-separator in strings, it might be possible that selectors get added several times. we should make the vector unique
			matches = matches.sort(SpecificityComparator.staticCompare);


			return matches;
		}


	}
}