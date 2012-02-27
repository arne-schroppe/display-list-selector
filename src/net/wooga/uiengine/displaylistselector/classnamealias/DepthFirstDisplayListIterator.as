package net.wooga.uiengine.displaylistselector.classnamealias {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import org.as3commons.collections.framework.IIterator;

	public class DepthFirstDisplayListIterator implements IIterator {
		private var _rootObject:DisplayObjectContainer;

		private var _next:DisplayObject;


		public function DepthFirstDisplayListIterator(rootObject:DisplayObjectContainer) {
			_rootObject = rootObject;

			advanceToDeepestObject(_rootObject);
		}

		private function advanceToDeepestObject(cursor:DisplayObject):void {
			var container:DisplayObjectContainer = cursor as DisplayObjectContainer;
			if (cursor is DisplayObjectContainer && container.numChildren > 0) {
				var newCursor:DisplayObject = container.getChildAt(0);
				advanceToDeepestObject(newCursor);
			} else {
				_next = cursor;
			}
		}

		public function hasNext():Boolean {
			return _next != null;
		}

		public function next():* {
			if (_next == null) {
				return undefined;
			}

			var current:DisplayObject = _next;
			advanceCursor();
			return current;
		}


		private function advanceCursor():void {
			var current:DisplayObject = _next;
			if (current == _rootObject) {
				_next = null;
				return;
			}

			_next = nextSibling(current);

			if (_next == null) { //is last in container

				_next = current.parent;
			}
			else if (_next is DisplayObjectContainer) {
				advanceToDeepestObject(_next);
			}

			//is next sibling
		}


		private function nextSibling(cursor:DisplayObject):DisplayObject {
			var container:DisplayObjectContainer = cursor.parent;
			var currentPosition:int = container.getChildIndex(cursor);
			var nextPosition:int = currentPosition + 1;
			if (nextPosition < container.numChildren) {
				return container.getChildAt(nextPosition);
			}
			else {
				return null;
			}
		}

	}
}
