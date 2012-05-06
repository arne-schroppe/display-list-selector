package net.wooga.selectors.matching.matchersequence {

	import net.wooga.selectors.matching.matchers.*;
	import net.wooga.selectors.matching.combinators.Combinator;

	public interface MatcherSequence {

		function get parentCombinator():Combinator;
		function get elementMatchers():Vector.<Matcher>;
		function get normalizedSelectorSequenceString():String;

	}
}
