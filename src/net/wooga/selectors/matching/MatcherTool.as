package net.wooga.selectors.matching {

	import net.wooga.selectors.adaptermap.ISelectorAdapterSource;
	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.matching.matchers.implementations.combinators.Combinator;
	import net.wooga.selectors.matching.matchers.implementations.combinators.CombinatorType;
	import net.wooga.selectors.matching.matchers.implementations.combinators.MatcherFamily;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class MatcherTool {

		private var _rootObject:Object;

		private var _currentlyMatchedMatchers:Vector.<IMatcher>;
		private var _adapterSource:ISelectorAdapterSource;

		public function MatcherTool(rootObject:Object, objectToAdapterMap:ISelectorAdapterSource) {
			_rootObject = rootObject;
			_adapterSource = objectToAdapterMap;
		}


		public function isObjectMatching(adapter:ISelectorAdapter, matchers:Vector.<IMatcher>):Boolean {

			_currentlyMatchedMatchers = matchers;

			if (_currentlyMatchedMatchers.length == 0) {
				return true;
			}

			return reverseMatch(adapter, _currentlyMatchedMatchers.length - 1);
		}



		private function reverseMatch(subject:ISelectorAdapter, nextMatcher:int):Boolean {

			if (!subject) {
				return false;
			}

			var retryParent:Boolean = false;
			var retrySibling:Boolean = false;
			var startMatcherIndex:int = nextMatcher;

			var nextMatcherObject:IMatcher = IMatcher(_currentlyMatchedMatchers[nextMatcher]);

			if(nextMatcherObject.matcherFamily != MatcherFamily.SIMPLE_MATCHER) {
				var nextMatcherAsCombinator:Combinator = nextMatcherObject as Combinator;

				nextMatcher--;
				if (nextMatcherAsCombinator.type == CombinatorType.DESCENDANT) {
					retryParent = true;
				}
				if (nextMatcherAsCombinator.type == CombinatorType.GENERAL_SIBLING) {
					retrySibling = true;
				}
			}



			var proceedWithParent:Boolean; //if false: proceed with previous *siblings*
			for (var i:int = nextMatcher; i >= 0; --i) {
				var matcher:IMatcher = _currentlyMatchedMatchers[i];

				if (!matcher.isMatching(subject)) {
					if(retryParent || retrySibling) {
						break
					}
					else {
						return false;
					}
				}

				if (matcher.matcherFamily == MatcherFamily.ANCESTOR_COMBINATOR) {
					proceedWithParent = true;
					break;
				}
				else if(matcher.matcherFamily == MatcherFamily.SIBLING_COMBINATOR) {
					proceedWithParent = false;
					break;
				}
			}


			if (i < 0) {
				return true;
			}

			var result:Boolean;
			if (i >= 0 && retryParent) {
				result = reverseMatchParentIfPossible(subject, startMatcherIndex);
				return result;
			}
			else if (i >= 0 && retrySibling){
				result = reverseMatchPreviousSiblingIfPossible(subject, startMatcherIndex);
				return result;
			}


			if(proceedWithParent) {
				result = reverseMatchParentIfPossible(subject, i);
			}
			else {
				result = reverseMatchPreviousSiblingIfPossible(subject, i);
			}


			return result;
		}

		private function reverseMatchParentIfPossible(subject:ISelectorAdapter, nextMatcher:int):Boolean {

			//TODO (arneschroppe 22/2/12)  should we use a isObjectEqualTo-method here ??
			if (subject.getAdaptedElement() == _rootObject) {
				return false;
			}

			return reverseMatch(_adapterSource.getSelectorAdapterForObject(subject.getParentElement()), nextMatcher);
		}


		private function reverseMatchPreviousSiblingIfPossible(subject:ISelectorAdapter, nextMatcher:int):Boolean {

			var objectIndex:int = subject.getElementIndex();
			if(objectIndex == 0) {
				return false;
			}

			var previousElement:Object = subject.getElementAtIndex(objectIndex - 1);
			return reverseMatch(_adapterSource.getSelectorAdapterForObject(previousElement), nextMatcher);
		}

	}
}
