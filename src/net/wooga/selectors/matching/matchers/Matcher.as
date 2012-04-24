package net.wooga.selectors.matching.matchers {

	import net.wooga.selectors.matching.matchers.implementations.combinators.MatcherFamily;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public interface Matcher {

		function get matcherFamily():MatcherFamily;
		function isMatching(subject:SelectorAdapter):Boolean;
	}
}
