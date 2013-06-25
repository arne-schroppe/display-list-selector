package net.wooga.selectors.matching.matchers {

	import net.wooga.selectors.matching.matchers.implementations.combinators.MatcherFamily;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public interface IMatcher {

		function get matcherFamily():MatcherFamily;
		function isMatching(subject:ISelectorAdapter):Boolean;
	}
}
