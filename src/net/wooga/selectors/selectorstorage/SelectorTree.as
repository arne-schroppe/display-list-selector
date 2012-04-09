package net.wooga.selectors.selectorstorage {

	import net.wooga.selectors.namespace.selector_internal;
	import net.wooga.selectors.parser.FilterData;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.selectorstorage.keys.HoverKey;
	import net.wooga.selectors.selectorstorage.keys.IdKey;
	import net.wooga.selectors.selectorstorage.keys.SelectorTreeNodeKey;
	import net.wooga.selectors.selectorstorage.keys.TypeNameKey;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;

	use namespace selector_internal;

	public class SelectorTree {


		private var _filterRoot:SelectorFilterTreeNode;
		private var _filterKeys:Vector.<SelectorTreeNodeKey> = new <SelectorTreeNodeKey>[
			new TypeNameKey(),
			new IdKey(),
			new HoverKey()
		];

		private var _numFilterKeys:int;
		private var _foundSelectors:Array;
		private var _selectorsWereAdded:Boolean;
		private var _filterDataExtractor:FilterDataExtractor = new FilterDataExtractor();


		public function SelectorTree() {
			_filterRoot = new SelectorFilterTreeNode();
			_numFilterKeys = _filterKeys.length;
		}



		public function add(parsedSelector:SelectorImpl):void {

			var filterData:FilterData = _filterDataExtractor.getFilterData(parsedSelector);

			_selectorsWereAdded = true;
			addToNode(_filterRoot, 0, parsedSelector, filterData);
		}


		private function addToNode(node:SelectorFilterTreeNode, keyIndex:int, selector:SelectorImpl, filterData:FilterData):Boolean {

			if(keyIndex >= _filterKeys.length) {
				return false;
			}

			var nodeKey:SelectorTreeNodeKey = _filterKeys[keyIndex] as SelectorTreeNodeKey;

			var hasKey:Boolean = nodeKey.selectorHasKey(selector, filterData);
			var key:*;
			if(hasKey) {
				key = nodeKey.keyForSelector(selector, filterData);
			}
			else {
				key = nodeKey.nullKey;
			}

			createKeyIfNeeded(node, key);

			var canPlaceSelector:Boolean = addToNode(node.childNodes[key], keyIndex + 1, selector, filterData);
			if(canPlaceSelector) {
				return true;
			}
			else if(hasKey) {
				var targetNode:SelectorFilterTreeNode = node.childNodes[key] as SelectorFilterTreeNode;
				targetNode.selectors.push(selector);
				return true;
			}
			else if(keyIndex == 0) {
				node.selectors.push(selector);
			}

			return false;
		}


		private function createKeyIfNeeded(node:SelectorFilterTreeNode, key:*):void {
			if(!node.childNodes.hasOwnProperty(key)) {
				node.childNodes[key] = new SelectorFilterTreeNode();
			}
		}


		public function getPossibleMatchesFor(object:SelectorAdapter):Array {

			if(_selectorsWereAdded) {
				invalidateAllKeyCaches();
				_selectorsWereAdded = false;
			}

			_foundSelectors = [];
			searchForMatches(_filterRoot, 0, object);
			return _foundSelectors;
		}


		private function searchForMatches(node:SelectorFilterTreeNode, keyIndex:int, adapter:SelectorAdapter):void {

			if(!node) {
				return ;
			}

			_foundSelectors = _foundSelectors.concat(node.selectors);

			if(keyIndex >= _numFilterKeys) {
				return;
			}

			var nodeKey:SelectorTreeNodeKey = _filterKeys[keyIndex] as SelectorTreeNodeKey;
			var keys:Array = nodeKey.keysForAdapter(adapter, node.childNodes);

			var len:int = keys.length
			for(var i:int = 0; i < len; ++i ) {
				searchForMatches(node.childNodes[keys[i] as String] as SelectorFilterTreeNode, keyIndex + 1, adapter);
			}
		}

		//This is currently only used by the TypeNameKey (asc 2012-03-15)
		private function invalidateAllKeyCaches():void {
			for each(var key:SelectorTreeNodeKey in _filterKeys) {
				key.invalidateCaches();
			}
		}
	}
}
