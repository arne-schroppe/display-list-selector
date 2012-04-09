package net.wooga.selectors.usagepatterns.implementations {

	import flash.utils.Dictionary;

	import net.wooga.selectors.PseudoElementSource;
	import net.wooga.selectors.matching.MatcherTool;
	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.namespace.selector_internal;
	import net.wooga.selectors.parser.FilterData;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.usagepatterns.*;

	use namespace selector_internal;

	public class SelectorImpl extends SelectorDescriptionImpl implements Selector, MatchedSelector {

		private var _objectToSelectorAdapterMap:Dictionary;
		private var _matcherTool:MatcherTool;
		private var _matchers:Vector.<Matcher> = new <Matcher>[];
		private var _filterData:FilterData = new FilterData();
		private var _pseudoElementName:String;
		private var _pseudoElementSource:PseudoElementSource;

		//TODO (arneschroppe 09/04/2012) this is only used by selector pool, make more elegant. we shouldn't keep a reference to this
		private var _matchedObject:Object;


		public function isMatching(object:Object):Boolean {
			var adapter:SelectorAdapter = _objectToSelectorAdapterMap[object];
			if(!adapter) {
				throw new ArgumentError("No selector adapter registered for object " + object);
			}

			return _matcherTool.isObjectMatching(adapter, _matchers);
		}


		selector_internal function set pseudoElementName(value:String):void {
			_pseudoElementName = value;
		}

		selector_internal function get pseudoElementName():String {
			return _pseudoElementName;
		}

		selector_internal function set pseudoElementSource(value:PseudoElementSource):void {
			_pseudoElementSource = value;
		}

		selector_internal function get pseudoElementSource():PseudoElementSource {
			return _pseudoElementSource;
		}

		selector_internal function set objectToSelectorAdapterMap(value:Dictionary):void {
			_objectToSelectorAdapterMap = value;
		}

		selector_internal function set matcherTool(value:MatcherTool):void {
			_matcherTool = value;
		}


		selector_internal function set matchers(value:Vector.<Matcher>):void {
			_matchers = value;
		}

		selector_internal function get matchers():Vector.<Matcher> {
			return _matchers;
		}





		//TODO (arneschroppe 14/3/12) it might be good to get rid of this object
		selector_internal function get filterData():FilterData {
			return _filterData;
		}


		public function getMatchedObjectFor(object:Object):Object {
			if(!isMatching(object)) {
				return null;
			}
			if(_pseudoElementName) {
				return _pseudoElementSource.pseudoElementForIdentifier(object, _pseudoElementName);
			}
			
			return object;
		}


		selector_internal function set matchedObject(value:Object):void {
			_matchedObject = value;
		}

		selector_internal function get matchedObject():Object {
			return _matchedObject;
		}


		public function getMatchedObject():Object {
			if(_pseudoElementName) {
				return _pseudoElementSource.pseudoElementForIdentifier(_matchedObject, _pseudoElementName);
			}

			return _matchedObject;
		}
	}
}
