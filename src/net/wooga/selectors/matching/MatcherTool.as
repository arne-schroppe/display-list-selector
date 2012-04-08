package net.wooga.selectors.matching {

	import flash.utils.Dictionary;

	import net.wooga.selectors.matching.matchers.GenericDescendantCombinator;
	import net.wooga.selectors.matching.matchers.SiblingCombinator;
	import net.wooga.selectors.matching.matchers.Matcher;
	import net.wooga.selectors.matching.matchers.implementations.combinators.AdjacentSiblingCombinator;
	import net.wooga.selectors.matching.matchers.implementations.combinators.ChildCombinator;
	import net.wooga.selectors.matching.matchers.implementations.combinators.DescendantCombinator;
	import net.wooga.selectors.matching.matchers.implementations.combinators.GeneralSiblingCombinator;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class MatcherTool {

		private var _rootObject:Object;

		private var _currentlyMatchedMatchers:Vector.<Matcher>;
		private var _objectToAdapterMap:Dictionary; //TODO (arneschroppe 08/04/2012) use interface here?

		public function MatcherTool(rootObject:Object, objectToAdapterMap:Dictionary) {
			_rootObject = rootObject;
			_objectToAdapterMap = objectToAdapterMap;
		}


		public function isObjectMatching(adapter:SelectorAdapter, matchers:Vector.<Matcher>):Boolean {

			_currentlyMatchedMatchers = matchers;

			if (_currentlyMatchedMatchers.length == 0) {
				return true;
			}

			return reverseMatch(adapter, _currentlyMatchedMatchers.length - 1);
		}



		private function reverseMatch(subject:SelectorAdapter, nextMatcher:int):Boolean {

			if (!subject) {
				return false;
			}

			var retryParent:Boolean = false;
			var retrySibling:Boolean = false;
			var startMatcherIndex:int = nextMatcher;

			if (_currentlyMatchedMatchers[nextMatcher] is ChildCombinator) {
				nextMatcher--;
			}
			else if (_currentlyMatchedMatchers[nextMatcher] is DescendantCombinator) {
				nextMatcher--;
				retryParent = true;
			}
			else if (_currentlyMatchedMatchers[nextMatcher] is AdjacentSiblingCombinator) {
				nextMatcher--;
			}
			else if (_currentlyMatchedMatchers[nextMatcher] is GeneralSiblingCombinator) {
				nextMatcher--;
				retrySibling = true;
			}


			var proceedWithParent:Boolean; //alternative is to proceed with previous siblings
			for (var i:int = nextMatcher; i >= 0; --i) {
				var matcher:Matcher = _currentlyMatchedMatchers[i];

				if (!matcher.isMatching(subject)) {
					if(retryParent || retrySibling) {
						break
					}
					else {
						return false;
					}
				}

				//TODO (arneschroppe 08/04/2012) "is" is slow, use a property instead
				if (matcher is GenericDescendantCombinator) {
					proceedWithParent = true;
					break;
				}
				else if(matcher is SiblingCombinator) {
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

		private function reverseMatchParentIfPossible(subject:SelectorAdapter, nextMatcher:int):Boolean {

			//TODO (arneschroppe 22/2/12) we should use a isObjectEqualTo-method here
			if (subject.getAdaptedElement() == _rootObject) {
				return false;
			}

			return reverseMatch(_objectToAdapterMap[subject.getParentElement()], nextMatcher);
		}


		private function reverseMatchPreviousSiblingIfPossible(subject:SelectorAdapter, nextMatcher:int):Boolean {

			var objectIndex:int = subject.getElementIndex();
			if(objectIndex == 0) {
				return false;
			}

			var previousElement:Object = subject.getElementAtIndex(objectIndex - 1);
			return reverseMatch(_objectToAdapterMap[previousElement], nextMatcher);
		}

	}
}
