package net.wooga.selectors.matching.matchers {
	import net.wooga.selectors.matching.matchers.implementations.combinators.Combinator;

	public interface MatcherSequence {

		function get parentCombinator():Combinator;
		function get elementMatchers():Vector.<Matcher>;
		function get normalizedSelectorSequenceString():String;

	}
}
