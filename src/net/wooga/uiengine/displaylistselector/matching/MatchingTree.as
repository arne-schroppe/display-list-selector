package net.wooga.uiengine.displaylistselector.matching {
	import flash.display.DisplayObjectContainer;

	import net.wooga.uiengine.displaylistselector.selector.ISelector;
	import net.wooga.uiengine.displaylistselector.selector.SelectorPath;

	import org.as3commons.collections.framework.ISet;

	public class MatchingTree {
		private var _rootView:Object;

		public function MatchingTree(rootView:Object) {
			_rootView = rootView;
		}

		public function addSelector(sel:ISelector):void {

		}

		public function getSelectorsMatchingPath(selectorPath:SelectorPath):ISet {
			return null;
		}

	}
}
