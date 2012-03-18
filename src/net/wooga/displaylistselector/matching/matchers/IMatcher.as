package net.wooga.displaylistselector.matching.matchers {

	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

	public interface IMatcher {

		function isMatching(subject:ISelectorAdapter):Boolean;

		//TODO (arneschroppe 6/1/12) add "isVolatile" property: Whether this matcher could match differently if object changes
	}
}
