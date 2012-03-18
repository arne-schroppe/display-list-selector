package net.wooga.selectors.usagepatterns.implementations {

	import net.wooga.selectors.matching.MatcherTool;
	import net.wooga.selectors.usagepatterns.*;
	import net.wooga.selectors.parser.Parser;
	import net.wooga.selectors.selector_internal;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;
	import net.wooga.selectors.selectorstorage.SelectorTree;
	import net.wooga.selectors.tools.SpecificityComparator;

	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMap;

	public class SelectorPoolImpl implements SelectorPool {

		use namespace selector_internal;

		private var _matcher:MatcherTool;
		private var _objectToStyleAdapterMap:IMap;
		private var _parser:Parser;

		private var _knownSelectors:SelectorTree = new SelectorTree();


		public function SelectorPoolImpl(parser:Parser, matcher:MatcherTool, objectToStyleAdapterMap:IMap) {
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
			var adapter:ISelectorAdapter = _objectToStyleAdapterMap.itemFor(object);
			if(!adapter) {
				throw new ArgumentError("No style adapter registered for object " + object);
			}

			var matches:Vector.<SelectorDescription> = new <SelectorDescription>[];

			var possibleMatches:IIterable = _knownSelectors.getPossibleMatchesFor(adapter);

			var keyIterator:IIterator = possibleMatches.iterator();
			while (keyIterator.hasNext()) {
				var selector:SelectorImpl = keyIterator.next();

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
