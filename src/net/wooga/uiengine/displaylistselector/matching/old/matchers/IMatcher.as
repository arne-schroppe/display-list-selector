package net.wooga.uiengine.displaylistselector.matching.old.matchers {
	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public interface IMatcher {

		function isMatching(subject:IStyleAdapter):Boolean;

		//TODO (arneschroppe 6/1/12) add "isVolatile" property: Whether this matcher could match differently if object changes
	}
}
