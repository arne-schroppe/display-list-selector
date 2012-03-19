package net.wooga.selectors.selectorstorage {

	import org.as3commons.collections.Map;
	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.collections.framework.ISet;

	public class SelectorFilterTreeNode {

		private var _selectors:ISet = new Set();
		private var _childNodes:IMap = new Map();

		public function get selectors():ISet {
			return _selectors;
		}

		public function get childNodes():IMap {
			return _childNodes;
		}
	}
}
