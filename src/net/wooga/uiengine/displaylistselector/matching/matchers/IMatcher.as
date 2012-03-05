package net.wooga.uiengine.displaylistselector.matching.matchers {
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	public interface IMatcher {

		function isMatching(subject:ISelectorAdapter):Boolean;

		//TODO (arneschroppe 6/1/12) add "isVolatile" property: Whether this matcher could match differently if object changes
	}
}
