package net.wooga.uiengine.displaylistselector {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import net.wooga.uiengine.displaylistselector.matchers.MatcherTool;

	public class SelectorContext {

		private var _rootObject:DisplayObjectContainer;


		public function initializeWith(rootObject:DisplayObjectContainer):void {
			_rootObject = rootObject;


		}

		public function objectWasChanged(object:DisplayObject):void {

		}

		public function get matcherTool():MatcherTool {
			return null;
		}
	}
}
