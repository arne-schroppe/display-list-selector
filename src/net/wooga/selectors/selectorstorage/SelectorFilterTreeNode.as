package net.wooga.selectors.selectorstorage {

	import flash.utils.Dictionary;

	public class SelectorFilterTreeNode {

		private var _selectors:Array = [];
		private var _childNodes:Dictionary = new Dictionary();

		public function get selectors():Array {
			return _selectors;
		}

		public function get childNodes():Dictionary {
			return _childNodes;
		}
	}
}
