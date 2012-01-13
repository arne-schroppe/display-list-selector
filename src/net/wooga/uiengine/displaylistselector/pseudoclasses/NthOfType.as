package net.wooga.uiengine.displaylistselector.pseudoclasses {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import net.wooga.uiengine.displaylistselector.pseudoclasses.nthchildren.NthOfX;

	public class NthOfType extends NthOfX {

		override protected function indexOfObject(subject:DisplayObject):int {
			var parent:DisplayObjectContainer = subject.parent;
			var index:int = 0;
			var SubjectType:Class = getDefinitionByName(getQualifiedClassName(subject)) as Class;
			var current:DisplayObject;

			for (var i:int = 0; i < parent.numChildren; ++i) {
				current = parent.getChildAt(i);

				if (current == subject) {
					return index;
				}

				if (current is SubjectType) {
					++index;
				}
			}

			throw new Error("object is not child of it's parent");
		}
	}
}
