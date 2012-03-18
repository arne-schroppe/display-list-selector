package net.wooga.displaylistselector.newtypes.implementations {

	import net.wooga.displaylistselector.matching.MatcherTool;
	import net.wooga.displaylistselector.matching.matchers.IMatcher;
	import net.wooga.displaylistselector.newtypes.*;
	import net.wooga.displaylistselector.parser.FilterData;
	import net.wooga.displaylistselector.selector_internal;
	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

	import org.as3commons.collections.framework.IMap;

	use namespace selector_internal;

	public class SelectorImpl extends SelectorDescriptionImpl implements Selector {

		private var _objectToStyleAdapterMap:IMap;
		private var _matcherTool:MatcherTool;
		private var _matchers:Vector.<IMatcher> = new <IMatcher>[];
		private var _filterData:FilterData = new FilterData();



		public function isMatching(object:Object):Boolean {
			var adapter:ISelectorAdapter = _objectToStyleAdapterMap.itemFor(object);
			if(!adapter) {
				throw new ArgumentError("No style adapter registered for object " + object);
			}

			return _matcherTool.isObjectMatching(adapter, _matchers);
		}


		selector_internal function set objectToStyleAdapterMap(value:IMap):void {
			_objectToStyleAdapterMap = value;
		}

		selector_internal function set matcherTool(value:MatcherTool):void {
			_matcherTool = value;
		}


		selector_internal function set matchers(value:Vector.<IMatcher>):void {
			_matchers = value;
		}

		selector_internal function get matchers():Vector.<IMatcher> {
			return _matchers;
		}

		//TODO (arneschroppe 14/3/12) it might be good to get rid of this object
		selector_internal function get filterData():FilterData {
			return _filterData;
		}


	}
}
