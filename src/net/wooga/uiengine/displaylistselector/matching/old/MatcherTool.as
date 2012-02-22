package net.wooga.uiengine.displaylistselector.matching.old {
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.ICombinator;
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.implementations.ChildSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.implementations.DescendantSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public class MatcherTool {

		private var _rootObject:Object;

		private var _currentlyMatchedMatchers:Vector.<IMatcher>;
		private var _currentlyMatchedSelector:String;


		public function MatcherTool(rootObject:Object) {
			_rootObject = rootObject;
		}



		public function invalidateObject(object:Object):void {

		}




		//TODO (arneschroppe 9/1/12) write a test for this!!!!!!
		public function isObjectMatching(adapter:IStyleAdapter, matchers:Vector.<ParsedSelector>):Boolean {


			for each(var currentMatchers:ParsedSelector in matchers) {
				_currentlyMatchedMatchers = currentMatchers.matchers;
				_currentlyMatchedSelector = currentMatchers.selector;

				if (_currentlyMatchedMatchers.length == 0) {
					continue;
				}
				else {
					var isMatching:Boolean = reverseMatch(adapter, _currentlyMatchedMatchers.length - 1);
					//var isMatching:Boolean = reverseMatch(adapter, )
					if(isMatching) {
						return true;
					}
				}
			}

			return false;
		}


		private function reverseMatch(subject:IStyleAdapter, nextMatcher:int):Boolean {

			trace("Matching " + subject.getAdaptedElement());

			if (!subject) {
				trace("no subject!");
				return false;
			}


			var retryParent:Boolean = false;
			if (currentMatcherIsChildMatcher(nextMatcher)) {
				nextMatcher--;
			}

			if (currentMatcherIsDescendantMatcher(nextMatcher)) {
				trace("Found descendantmatcher")
				nextMatcher--;
				retryParent = true;
			}


			for (var i:int = nextMatcher; i >= 0; --i) {
				var matcher:IMatcher = _currentlyMatchedMatchers[i];

				trace("matcher: " + matcher);
				if (!matcher.isMatching(subject)) {
					trace("did not match!");
					if(retryParent) {
						break
					}
					else {
						return false;
					}

				}

				if (matcher is ICombinator) {
					break;
				}
			}


			var result:Boolean;
			if (i >= 0 && retryParent) { //TODO (arneschroppe 6/2/12) specifically test this line!

				result = reverseMatchParentIfPossible(subject, nextMatcher);

				trace("parent result: " + result);
				return result;
			}


			if (i < 0) {
				trace("SUCCESS!");
				return true;
			}


			result = reverseMatchParentIfPossible(subject, i);
			trace("this result: " + result);
			return result;
		}

		private function reverseMatchParentIfPossible(subject:IStyleAdapter, nextMatcher:int):Boolean {
			if (subject.getAdaptedElement() == _rootObject) {
				return false;
			}

			return reverseMatch(subject.getParent(), nextMatcher);
		}


		private function currentMatcherIsChildMatcher(currentIndex:int):Boolean {
			return _currentlyMatchedMatchers[currentIndex] is ChildSelectorMatcher;
		}

		private function currentMatcherIsDescendantMatcher(currentIndex:int):Boolean {
			return _currentlyMatchedMatchers[currentIndex] is DescendantSelectorMatcher;
		}


	}
}
