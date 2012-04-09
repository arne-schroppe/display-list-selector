package net.wooga.selectors.selectorstorage {

	import flash.utils.Dictionary;

	import net.wooga.selectors.namespace.selector_internal;
	import net.wooga.selectors.parser.FilterData;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.selectorstorage.keys.HoverKey;
	import net.wooga.selectors.selectorstorage.keys.IdKey;
	import net.wooga.selectors.selectorstorage.keys.SelectorTreeNodeKey;
	import net.wooga.selectors.selectorstorage.keys.TypeNameKey;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;

	use namespace selector_internal;

	public class SelectorFilter {


		//private var _filterRoot:SelectorFilterTreeNode;

		private var _filterKeys:Vector.<SelectorTreeNodeKey> = new <SelectorTreeNodeKey>[
			new TypeNameKey(),
			new IdKey(),
			new HoverKey()
		];

		private var _numFilterKeys:int;
		//private var _foundSelectors:Array;

		private var _selectorsWereAdded:Boolean;

		private var _filterDataExtractor:FilterDataExtractor = new FilterDataExtractor();

		private var _map:Dictionary = new Dictionary();

		public function SelectorFilter() {
			//_filterRoot = new SelectorFilterTreeNode();
			_numFilterKeys = _filterKeys.length;
			_map["@"] = [];
		}



		public function add(parsedSelector:SelectorImpl):void {

			var filterData:FilterData = _filterDataExtractor.getFilterData(parsedSelector);
			_selectorsWereAdded = true;

			addToNode("", 0, parsedSelector, filterData);
		}


		private function addToNode(previousKey:String, keyIndex:int, selector:SelectorImpl, filterData:FilterData):Boolean {

			if(keyIndex >= _filterKeys.length) {
				return false;
			}

			var nodeKey:SelectorTreeNodeKey = _filterKeys[keyIndex] as SelectorTreeNodeKey;

			var hasKey:Boolean = nodeKey.selectorHasKey(selector, filterData);
			var key:String;
			if(hasKey) {
				key = nodeKey.keyForSelector(selector, filterData);
			}
			else {
				key = nodeKey.nullKey;
			}


			var canPlaceSelector:Boolean = addToNode(previousKey + "&&" + key, keyIndex + 1, selector, filterData);
			if(canPlaceSelector) {
				return true;
			}
			else if(hasKey) {
				addToKey(key, selector)
				return true;
			}
			
			//we're in root key
			else if(keyIndex == 0) {
				(_map["@"] as Array).push(selector);
			}

			return false;
		}

		private function addToKey(key:String, selector:SelectorImpl):void {
			if(!(key in _map)) {
				_map[key] = [];
			}

			(_map[key] as Array).push(selector);
			
		}



		public function getPossibleMatchesFor(object:SelectorAdapter):Array {

			if(_selectorsWereAdded) {
				invalidateAllKeyCaches();
				_selectorsWereAdded = false;
			}

			var keys:Array = searchForMatches([""], 0, object);

			var selectors:Array = [].concat(_map["@"]);
			for each(var key:String in keys) {
				trace("Key: " + key)
				selectors.concat(_map[key] as Array);
			}

			return selectors;
		}


		private function searchForMatches(previousKeys:Array, keyIndex:int, adapter:SelectorAdapter):Array {


			if(keyIndex >= _numFilterKeys) {
				return previousKeys;
			}

			var nodeKey:SelectorTreeNodeKey = _filterKeys[keyIndex] as SelectorTreeNodeKey;
			var keys:Array = nodeKey.keysForAdapter(adapter);

			var len:int = keys.length
			var newKeys:Array = [];
			for(var i:int = 0; i < len; ++i ) {
				for(var j:int = 0; j < previousKeys.length; ++j ) {
					newKeys.push(previousKeys[j] + "&&" + keys[i]);
				}
			}


			return searchForMatches(newKeys, keyIndex + 1, adapter);
		}

		//This is currently only used by the TypeNameKey (asc 2012-03-15)
		private function invalidateAllKeyCaches():void {
			for each(var key:SelectorTreeNodeKey in _filterKeys) {
				key.invalidateCaches();
			}
		}
	}
}
