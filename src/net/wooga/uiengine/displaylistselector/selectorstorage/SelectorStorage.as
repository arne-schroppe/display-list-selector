package net.wooga.uiengine.displaylistselector.selectorstorage {
	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.selectorstorage.keys.HoverKey;
	import net.wooga.uiengine.displaylistselector.selectorstorage.keys.ISelectorTreeNodeKey;
	import net.wooga.uiengine.displaylistselector.selectorstorage.keys.IdKey;
	import net.wooga.uiengine.displaylistselector.selectorstorage.keys.TypeNameKey;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	import org.as3commons.collections.Set;

	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.ISet;
	import org.as3commons.collections.utils.Sets;

	public class SelectorStorage {


		private var _filterRoot:SelectorFilterTreeNode;
		private var _filterKeys:Vector.<ISelectorTreeNodeKey> = new <ISelectorTreeNodeKey>[
			new TypeNameKey(),
			new IdKey(),
			new HoverKey()
		];

		private var _foundSelectors:ISet;

		public function SelectorStorage() {

			_filterRoot = new SelectorFilterTreeNode();
			//createNullKey(_filterRoot, 0);
		}

//		private function createNullKey(node:SelectorFilterTreeNode, keyIndex:int):void {
//
//			if(keyIndex >= _filterKeys.length) {
//				return;
//			}
//
//			var key:ISelectorTreeNodeKey = _filterKeys[keyIndex];
//			var newNode:SelectorFilterTreeNode = new SelectorFilterTreeNode();
//			node.childNodes.add(key.nullKey, newNode);
//
//			createNullKey(newNode, keyIndex + 1);
//		}


		public function add(parsedSelector:ParsedSelector):void {
			addToNode(_filterRoot, 0, parsedSelector);
		}


		private function addToNode(node:SelectorFilterTreeNode, keyIndex:int, selector:ParsedSelector):Boolean {
			
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


		public function getPossibleMatchesFor(object:IStyleAdapter):IIterable {

			_foundSelectors = new Set();

			searchForMatches(_filterRoot, 0, object);

			return _foundSelectors;

		}

		private function searchForMatches(node:SelectorFilterTreeNode, keyIndex:int, adapter:IStyleAdapter):void {

			if(!node) {
				return;
			}
			
			Sets.addFromCollection(_foundSelectors, node.selectors);

			if(keyIndex >= _filterKeys.length) {
				return;
			}

			var nodeKey:ISelectorTreeNodeKey = _filterKeys[keyIndex];
			var key:* = nodeKey.keyForAdapter(adapter);

			searchForMatches(node.childNodes.itemFor(nodeKey.nullKey), keyIndex + 1, adapter);
			searchForMatches(node.childNodes.itemFor(key), keyIndex + 1, adapter);
			
		}
	}
}
