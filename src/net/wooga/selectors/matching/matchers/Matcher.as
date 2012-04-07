package net.wooga.selectors.matching.matchers {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public interface Matcher {

		function isMatching(subject:SelectorAdapter):Boolean;

		//TODO (arneschroppe 6/1/12) add "isVolatile" property: Whether this matcher could match differently if object changes
	}
}
