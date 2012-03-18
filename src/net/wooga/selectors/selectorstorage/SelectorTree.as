package net.wooga.selectors.selectorstorage {

	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;
	import net.wooga.selectors.selectorstorage.keys.HoverKey;
	import net.wooga.selectors.selectorstorage.keys.ISelectorTreeNodeKey;
	import net.wooga.selectors.selectorstorage.keys.IdKey;
	import net.wooga.selectors.selectorstorage.keys.TypeNameKey;

	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.ISet;
	import org.as3commons.collections.utils.Sets;

	public class SelectorTree {


		private var _filterRoot:SelectorFilterTreeNode;
		private var _filterKeys:Vector.<ISelectorTreeNodeKey> = new <ISelectorTreeNodeKey>[
			new TypeNameKey(),
			new IdKey(),
			new HoverKey()
		];

		private var _foundSelectors:ISet;

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

			var nodeKey:ISelectorTreeNodeKey = _filterKeys[keyIndex];

			var hasKey:Boolean = nodeKey.selectorHasKey(selector);
			var key:*;
			if(hasKey) {
				key = nodeKey.keyForSelector(selector);
			}
			else {
				key = nodeKey.nullKey;
			}

			createKeyIfNeeded(node, key);

			var canPlaceSelector:Boolean = addToNode(node.childNodes.itemFor(key), keyIndex + 1, selector);
			if(canPlaceSelector) {
				return true;
			}
			else if(hasKey) {
				var targetNode:SelectorFilterTreeNode = node.childNodes.itemFor(key);
				targetNode.selectors.add(selector);
				return true;
			}
			else if(keyIndex == 0) {
				node.selectors.add(selector);
			}

			return false;
		}


		private function createKeyIfNeeded(node:SelectorFilterTreeNode, key:*):void {
			if(!node.childNodes.hasKey(key)) {
				node.childNodes.add(key, new SelectorFilterTreeNode());
			}
		}


		public function getPossibleMatchesFor(object:ISelectorAdapter):IIterable {
			_foundSelectors = new Set();
			searchForMatches(_filterRoot, 0, object);
			return _foundSelectors;
		}

		private function searchForMatches(node:SelectorFilterTreeNode, keyIndex:int, adapter:ISelectorAdapter):void {

			if(!node) {
				return;
			}
			
			if(_selectorsWereAdded) {
				invalidateAllKeyCaches();
				_selectorsWereAdded = false;
			}
			
			Sets.addFromCollection(_foundSelectors, node.selectors);

			if(keyIndex >= _filterKeys.length) {
				return;
			}

			var nodeKey:ISelectorTreeNodeKey = _filterKeys[keyIndex];
			var keys:Array = nodeKey.keysForAdapter(adapter, node.childNodes);

			for each(var key:String in keys) {
				searchForMatches(node.childNodes.itemFor(key), keyIndex + 1, adapter);
			}
		}

		//This is currently only used by the TypeNameKey (asc 2012-03-15)
		private function invalidateAllKeyCaches():void {
			for each(var key:ISelectorTreeNodeKey in _filterKeys) {
				key.invalidateCaches();
			}
		}
	}
}
