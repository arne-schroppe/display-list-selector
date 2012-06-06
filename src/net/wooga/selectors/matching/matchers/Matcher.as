package net.wooga.selectors.matching.matchers {

	import net.wooga.selectors.matching.combinators.MatcherFamily;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	//TODO (arneschroppe 06/06/2012) rename this to SimpleSelectorSequence. Remove the term "matcher" and replace it with terms from the standard. The Matcher is the Selector
	//TODO (arneschroppe 06/06/2012) also, move pseudoclasses under the "matching" package
	public interface Matcher {

		function get matcherFamily():MatcherFamily;
		function isMatching(subject:SelectorAdapter):Boolean;
	}
}
