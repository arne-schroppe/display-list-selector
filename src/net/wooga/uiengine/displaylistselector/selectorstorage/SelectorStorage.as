package net.wooga.uiengine.displaylistselector.selectorstorage {
	import net.wooga.uiengine.displaylistselector.parser.ParserResult;
	import net.wooga.uiengine.displaylistselector.selectorstorage.keys.ISelectorTreeNodeKey;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.IMap;

	public class SelectorStorage {

		private var _allSelectors:IMap = new Map();
		//private var _keys:ArrayList;

		private var _filterRoot:SelectorFilterTreeNode;

		private var _filterKeys:Vector.<ISelectorTreeNodeKey> = new <ISelectorTreeNodeKey>[


		];

		public function add(selectorString:String, parsedSelector:ParserResult):void {
			_allSelectors.add(selectorString, parsedSelector);

			//_keys = new ArrayList();
			//Lists.addFromArray(_keys, _allSelectors.keysToArray());
		}

		public function itemFor(selectorString:String):ParserResult {
			return _allSelectors.itemFor(selectorString);
		}

		public function getPossibleMatchesFor(object:IStyleAdapter):IIterable {
			return null;//_keys;
		}
	}
}
