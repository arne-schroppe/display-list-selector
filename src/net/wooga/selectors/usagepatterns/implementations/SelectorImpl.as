package net.wooga.selectors.usagepatterns.implementations {

	import flash.utils.Dictionary;

	import net.wooga.selectors.PseudoElementSource;
	import net.wooga.selectors.matching.MatcherTool;
	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.namespace.selector_internal;
	import net.wooga.selectors.parser.FilterData;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.tools.WeakReference;
	import net.wooga.selectors.tools.WeakReference;
	import net.wooga.selectors.usagepatterns.*;

	use namespace selector_internal;

	public class SelectorImpl extends SelectorDescriptionImpl implements Selector, MatchedSelector {

		private var _objectToSelectorAdapterMap:Dictionary;
		private var _matcherTool:MatcherTool;
		private var _matchers:Vector.<Matcher> = new <Matcher>[];
		private var _filterData:FilterData = new FilterData();
		private var _pseudoElementName:String;
		private var _pseudoElementSource:PseudoElementSource;

		private var _matchedObjectReference:WeakReference;


		public function isMatching(object:Object):Boolean {
			var adapter:SelectorAdapter = _objectToSelectorAdapterMap[object];
			if(!adapter) {
				throw new ArgumentError("No selector adapter registered for object " + object);
			}

			return _matcherTool.isObjectMatching(adapter, _matchers);
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



		public function getMatchedObject():Object {
			return _matchedObjectReference.referencedObject;
		}


		//TODO (arneschroppe 14/3/12) it might be good to get rid of this object
		selector_internal function get filterData():FilterData {
			return _filterData;
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

		//TODO (arneschroppe 09/04/2012) these are only used by MatchedSelector

		//Can be the actual display-object or the pseudo-element
		selector_internal function set matchedObjectReference(value:Object):void {
			if(_pseudoElementName) {
				_matchedObjectReference = new WeakReference(_pseudoElementSource.pseudoElementForIdentifier(value, _pseudoElementName));
			}
			else {
				_matchedObjectReference = new WeakReference(value);
			}

		}

		selector_internal function get matchedObjectReference():Object {
			return _matchedObjectReference;
		}

	}
}
