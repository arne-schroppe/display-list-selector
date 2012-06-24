package net.wooga.selectors.matching.matchersequence {

	import net.wooga.selectors.matching.combinators.Combinator;
	import net.wooga.selectors.matching.matchers.Matcher;

	public class MatcherSequenceImpl implements MatcherSequence{


		private var _elementMatchers:Vector.<Matcher> = new <Matcher>[];
		private var _normalizedSelectorSequenceString:String;
		private var _parentCombinator:Combinator;


		public function get parentCombinator():Combinator {
			return _parentCombinator;
		}

		public function get elementMatchers():Vector.<Matcher> {
			return _elementMatchers;
		}

		public function get normalizedSelectorSequenceString():String {
			return _normalizedSelectorSequenceString;
		}


		public function set normalizedSelectorSequenceString(value:String):void {
			_normalizedSelectorSequenceString = value;
		}

		public function set parentCombinator(value:Combinator):void {
			_parentCombinator = value;
		}
	}
}
