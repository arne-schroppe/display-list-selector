package net.wooga.uiengine.displaylistselector.matching.old.matchers {
	import flash.display.DisplayObject;

	public interface IMatcher {

		function isMatching(subject:DisplayObject):Boolean;

		//TODO (arneschroppe 6/1/12) add "isVolatile" property: Whether this matcher could match differently if object changes
	}
}
