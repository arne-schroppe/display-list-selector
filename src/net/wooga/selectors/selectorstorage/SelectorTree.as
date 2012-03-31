package net.wooga.selectors.selectorstorage {

	import net.wooga.selectors.matching.matchers.implementations.TypeNameMatcher;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.selectorstorage.keys.HoverKey;
	import net.wooga.selectors.selectorstorage.keys.IdKey;
	import net.wooga.selectors.selectorstorage.keys.SelectorTreeNodeKey;
	import net.wooga.selectors.selectorstorage.keys.TypeNameKey;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;

	public class SelectorTree {


		private var _filterRoot:SelectorFilterTreeNode;
		private var _filterKeys:Vector.<SelectorTreeNodeKey> = new <SelectorTreeNodeKey>[
			new TypeNameKey(),
			new IdKey(),
			new HoverKey()
		];

		private var _foundSelectors:Array;

		private var _selectorsWereAdded:Boolean;

		public function SelectorTree() {
			_filterRoot = new SelectorFilterTreeNode();
		}



		public function add(parsedSelector:SelectorImpl):void {
			_selectorsWereAdded = true;
			addToNode(_filterRoot, 0, parsedSelector);
		}


		private function addToNode(node:SelectorFilterTreeNode, keyIndex:int, selector:SelectorImpl):Boolean {
			
			if(keyIndex >= _filterKeys.length) {
				return false;
			}

			var nodeKey:SelectorTreeNodeKey = _filterKeys[keyIndex] as SelectorTreeNodeKey;

			var hasKey:Boolean = nodeKey.selectorHasKey(selector);
			var key:*;
			if(hasKey) {
				key = nodeKey.keyForSelector(selector);
			}
			else {
				key = nodeKey.nullKey;
			}

			createKeyIfNeeded(node, key);

			var canPlaceSelector:Boolean = addToNode(node.childNodes[key], keyIndex + 1, selector);
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
			_foundSelectors = [];
			searchForMatches(_filterRoot, 0, object);
			return _foundSelectors;
		}

		private function searchForMatches(node:SelectorFilterTreeNode, keyIndex:int, adapter:SelectorAdapter):void {

			if(!node) {
				return;
			}
			
			if(_selectorsWereAdded) {
				invalidateAllKeyCaches();
				_selectorsWereAdded = false;
			}

			//TODO (arneschroppe 19/3/12) use array here, this is too costly

			_foundSelectors = _foundSelectors.concat(node.selectors);
			
			if(keyIndex >= _filterKeys.length) {
				return;
			}

			var nodeKey:SelectorTreeNodeKey = _filterKeys[keyIndex];
			var keys:Array = nodeKey.keysForAdapter(adapter, node.childNodes);

			for each(var key:String in keys) {
				searchForMatches(node.childNodes[key], keyIndex + 1, adapter);
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
