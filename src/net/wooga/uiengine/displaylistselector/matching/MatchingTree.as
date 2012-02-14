package net.wooga.uiengine.displaylistselector.matching {
	import flash.display.DisplayObjectContainer;

	import net.wooga.uiengine.displaylistselector.selector.Selector;
	import net.wooga.uiengine.displaylistselector.selector.SelectorPath;

	import org.as3commons.collections.framework.ISet;

	public class MatchingTree {
		private var _rootView:DisplayObjectContainer;

		public function MatchingTree(rootView:DisplayObjectContainer) {
			_rootView = rootView;
		}

		public function addSelector(sel:Selector):void {

		}

		public function getSelectorsMatchingPath(selectorPath:SelectorPath):ISet {
			return null;
		}

	}
}
