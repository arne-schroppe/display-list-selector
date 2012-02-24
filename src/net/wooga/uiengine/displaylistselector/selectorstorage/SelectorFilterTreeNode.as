package net.wooga.uiengine.displaylistselector.selectorstorage {
	import net.wooga.uiengine.displaylistselector.selectorstorage.keys.ISelectorTreeNodeKey;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMap;

	public class SelectorFilterTreeNode {

		private var _selectors:Vector.<String> = new <String>[];
		private var _childNodes:IMap = new Map();


		private var _childNodeKey:ISelectorTreeNodeKey;
	}
}
