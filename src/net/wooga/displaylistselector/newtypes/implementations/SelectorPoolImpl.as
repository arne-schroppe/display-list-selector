package net.wooga.displaylistselector.newtypes.implementations {

	import net.wooga.displaylistselector.matching.MatcherTool;
	import net.wooga.displaylistselector.newtypes.*;
	import net.wooga.displaylistselector.parser.ParsedSelector;
	import net.wooga.displaylistselector.parser.Parser;
	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;
	import net.wooga.displaylistselector.selectorstorage.SelectorTree;
	import net.wooga.displaylistselector.tools.SpecificityComparator;

	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMap;

	public class SelectorPoolImpl implements SelectorPool {
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
			var parsed:Vector.<ParsedSelector> = _parser.parse(selectorString);

			for each(var selector:ParsedSelector in parsed) {
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
				var parsedSelector:ParsedSelector = keyIterator.next();

				if (_matcher.isObjectMatching(adapter, parsedSelector)) {

					//TODO (arneschroppe 3/18/12) use an object pool here, so we don't have the overhead of creating objects all the time. They're flyweight's anyway
					matches.push(new SelectorDescriptionImpl(parsedSelector.originalSelectorString, parsedSelector.specificity));
				}
			}

			matches.sort(SpecificityComparator.staticCompare);

			return matches;
		}


	}
}
