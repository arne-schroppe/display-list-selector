package net.wooga.selectors.matching {

	import net.wooga.selectors.adaptermap.SelectorAdapterSource;
	import net.wooga.selectors.matching.combinators.CombinatorType;
	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.matching.matchersequence.MatcherSequence;
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

			//TODO (arneschroppe 06/06/2012) give this to reversematch as parameter instead of field
			_currentlyMatchedMatcherSequences = matchers;

			if (_currentlyMatchedMatcherSequences.length == 0) {
				return true;
			}

			return reverseMatch(adapter);
		}



		private function reverseMatch(subject:SelectorAdapter):Boolean {

			var objectIndex:int;

			var continueWithParentOnFail:Boolean = false;
			var continueWithSiblingOnFail:Boolean = false;
			var hasMatch:Boolean = false;
			var parent:Object;

			var sequencesLength:int = _currentlyMatchedMatcherSequences.length;

			for (var i:int = sequencesLength - 1; i >= 0; --i) {


				var currentSequence:MatcherSequence = _currentlyMatchedMatcherSequences[i] as MatcherSequence;

				hasMatch = true;

				//TODO (arneschroppe 07/06/2012) also store if an element does NOT match a sequence, so we don't have to rematch that case

				if(!subject.hasSubSelectorMatchResult(currentSequence.normalizedSelectorSequenceString)) {

					var matchers:Vector.<Matcher> = currentSequence.elementMatchers;
					var matchersLength:int = matchers.length;
					for (var j:int = matchersLength - 1; j >= 0; --j) {
						var matcher:Matcher = matchers[j];
						if (!matcher.isMatching(subject)) {
							hasMatch = false;
							break;
						}
					}

					subject.setSubSelectorMatchResult(currentSequence.normalizedSelectorSequenceString, hasMatch);
				}
				else {
					hasMatch = subject.getSubSelectorMatchResult(currentSequence.normalizedSelectorSequenceString);
				}


				if(!hasMatch) {

					if(continueWithParentOnFail) {
						if (subject.getAdaptedElement() == _rootObject) {
							return false;
						}
						subject = _adapterSource.getSelectorAdapterForObject(subject.getParentElement());

					}
					else if(continueWithSiblingOnFail) {
						objectIndex = subject.getElementIndex();
						if(objectIndex == 0) {
							return false;
						}
						subject = _adapterSource.getSelectorAdapterForObject( subject.getElementAtIndex(objectIndex - 1) );
					}
					else {
						return false;
					}

					++i; //rematch current sequence
					continue;
				}


				if(!currentSequence.parentCombinator) {
					break;
				}


				if (subject.getAdaptedElement() == _rootObject) {
					return false;
				}


				switch(currentSequence.parentCombinator.type) {
					case CombinatorType.CHILD:
						continueWithParentOnFail = false;
						continueWithSiblingOnFail = false;
						if (subject.getAdaptedElement() == _rootObject) {
							return false;
						}
						parent = subject.getParentElement();
						subject = _adapterSource.getSelectorAdapterForObject(parent);
						break;


					case CombinatorType.DESCENDANT:
						continueWithParentOnFail = true;
						continueWithSiblingOnFail = false;
						if (subject.getAdaptedElement() == _rootObject) {
							return false;
						}
						subject = _adapterSource.getSelectorAdapterForObject(subject.getParentElement());
						break;


					case CombinatorType.ADJACENT_SIBLING:
						continueWithParentOnFail = false;
						continueWithSiblingOnFail = false;
						objectIndex = subject.getElementIndex();
						if(objectIndex == 0) {
							return false;
						}
						subject = _adapterSource.getSelectorAdapterForObject( subject.getElementAtIndex(objectIndex - 1) );
						break;


					case CombinatorType.GENERAL_SIBLING:
						continueWithParentOnFail = false;
						continueWithSiblingOnFail = true;
						objectIndex = subject.getElementIndex();
						if(objectIndex == 0) {
							return false;
						}
						subject = _adapterSource.getSelectorAdapterForObject( subject.getElementAtIndex(objectIndex - 1) );
						break;
				}
			}


			return true;
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

//		private function reverseMatchParentIfPossible(subject:SelectorAdapter, nextMatcher:int):Boolean {
//
//			//TODO (arneschroppe 22/2/12)  should we use a isObjectEqualTo-method here ??
//			if (subject.getAdaptedElement() == _rootObject) {
//				return false;
//			}
//
//			var parentAdapter:SelectorAdapter = _adapterSource.getSelectorAdapterForObject(subject.getParentElement());
//			//TODO (asc 4/5/12) check if adapter matches remaining partial selector
//			return reverseMatch(parentAdapter, nextMatcher);
//		}
//
//
//		private function reverseMatchPreviousSiblingIfPossible(subject:SelectorAdapter, nextMatcher:int):Boolean {
//
//			var objectIndex:int = subject.getElementIndex();
//			if(objectIndex == 0) {
//				return false;
//			}
//
//			var previousElement:Object = subject.getElementAtIndex(objectIndex - 1);
//			return reverseMatch(_adapterSource.getSelectorAdapterForObject(previousElement), nextMatcher);
//		}

	}
}
