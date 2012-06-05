package net.wooga.selectors.matching.matchersequence {

	import net.wooga.selectors.matching.matchers.*;
	import net.wooga.selectors.matching.combinators.Combinator;

	//A MatcherSequence is the combination of a combinator and the matchers for a simple selector sequence. It equates to the matchers for a single element (i.e. sprite / movie clip / etc. on stage) (asc 06/06/2012)
	public interface MatcherSequence {

		//parentCombinator is null for the first MatcherSequence
		function get parentCombinator():Combinator;

		function get elementMatchers():Vector.<Matcher>;

		function get normalizedSelectorSequenceString():String;

	}
}
