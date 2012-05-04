package net.wooga.selectors.matching {

	import net.wooga.selectors.adaptermap.SelectorAdapterSource;
	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.matching.matchers.MatcherSequence;
	import net.wooga.selectors.matching.matchers.implementations.combinators.Combinator;
	import net.wooga.selectors.matching.matchers.implementations.combinators.CombinatorType;
	import net.wooga.selectors.matching.matchers.implementations.combinators.MatcherFamily;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class MatcherTool {

		private var _rootObject:Object;

		private var _currentlyMatchedMatcherSequences:Vector.<MatcherSequence>;
		private var _adapterSource:SelectorAdapterSource;

		public function MatcherTool(rootObject:Object, objectToAdapterMap:SelectorAdapterSource) {
			_rootObject = rootObject;
			_adapterSource = objectToAdapterMap;
		}


		public function isObjectMatching(adapter:SelectorAdapter, matchers:Vector.<MatcherSequence>):Boolean {

			_currentlyMatchedMatcherSequences = matchers;

			if (_currentlyMatchedMatcherSequences.length == 0) {
				return true;
			}

			return reverseMatch(adapter, _currentlyMatchedMatcherSequences.length - 1);
		}



		private function reverseMatch(subject:SelectorAdapter, nextMatcher:int):Boolean {

			for (var i:int = _currentlyMatchedMatcherSequences.length - 1; i >= 0; --i) {

				var currentSequence:MatcherSequence = _currentlyMatchedMatcherSequences[i];

				var matchers:Vector.<Matcher> = currentSequence.elementMatchers;

				for (var j:int = matchers.length - 1; j >= 0; --j) {
					var matcher:Matcher = matchers[j];


				}

			}


			return false;
		}




		////TODO (asc 4/5/12) don't use recursion, limit method calls
		//private function reverseMatch(subject:SelectorAdapter, nextMatcher:int):Boolean {
		//
		//	if (!subject) {
		//		return false;
		//	}
		//
		//	var retryParent:Boolean = false;
		//	var retrySibling:Boolean = false;
		//	var startMatcherIndex:int = nextMatcher;
		//
		//	var nextMatcherObject:Matcher = Matcher(_currentlyMatchedMatcherSequences[nextMatcher]);
		//
		//	if(nextMatcherObject.matcherFamily != MatcherFamily.SIMPLE_MATCHER) {
		//		var nextMatcherAsCombinator:Combinator = nextMatcherObject as Combinator;
		//
		//		nextMatcher--;
		//		if (nextMatcherAsCombinator.type == CombinatorType.DESCENDANT) {
		//			retryParent = true;
		//		}
		//		if (nextMatcherAsCombinator.type == CombinatorType.GENERAL_SIBLING) {
		//			retrySibling = true;
		//		}
		//	}
		//
		//
		//	var proceedWithParent:Boolean; //if false: proceed with previous *siblings*
		//	for (var i:int = nextMatcher; i >= 0; --i) {
		//		var matcher:Matcher = _currentlyMatchedMatcherSequences[i];
		//
		//		if (!matcher.isMatching(subject)) {
		//			if(retryParent || retrySibling) {
		//				break
		//			}
		//			else {
		//				return false;
		//			}
		//		}
		//
		//		if (matcher.matcherFamily == MatcherFamily.ANCESTOR_COMBINATOR) {
		//			proceedWithParent = true;
		//			break;
		//		}
		//		else if(matcher.matcherFamily == MatcherFamily.SIBLING_COMBINATOR) {
		//			proceedWithParent = false;
		//			break;
		//		}
		//	}
		//
		//
		//	if (i < 0) {
		//		return true;
		//	}
		//
		//	var result:Boolean;
		//	if (i >= 0 && retryParent) {
		//		result = reverseMatchParentIfPossible(subject, startMatcherIndex);
		//		return result;
		//	}
		//	else if (i >= 0 && retrySibling){
		//		result = reverseMatchPreviousSiblingIfPossible(subject, startMatcherIndex);
		//		return result;
		//	}
		//
		//
		//	if(proceedWithParent) {
		//		result = reverseMatchParentIfPossible(subject, i);
		//	}
		//	else {
		//		result = reverseMatchPreviousSiblingIfPossible(subject, i);
		//	}
		//
		//
		//	return result;
		//}

		private function reverseMatchParentIfPossible(subject:SelectorAdapter, nextMatcher:int):Boolean {

			//TODO (arneschroppe 22/2/12)  should we use a isObjectEqualTo-method here ??
			if (subject.getAdaptedElement() == _rootObject) {
				return false;
			}

			var parentAdapter:SelectorAdapter = _adapterSource.getSelectorAdapterForObject(subject.getParentElement());
			//TODO (asc 4/5/12) check if adapter matches remaining partial selector
			return reverseMatch(parentAdapter, nextMatcher);
		}


		private function reverseMatchPreviousSiblingIfPossible(subject:SelectorAdapter, nextMatcher:int):Boolean {

			var objectIndex:int = subject.getElementIndex();
			if(objectIndex == 0) {
				return false;
			}

			var previousElement:Object = subject.getElementAtIndex(objectIndex - 1);
			return reverseMatch(_adapterSource.getSelectorAdapterForObject(previousElement), nextMatcher);
		}

	}
}
