package net.wooga.uiengine.displaylistselector.matching.old {
	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.matching.old.matchers.ICombinator;
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.implementations.ChildSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.implementations.DescendantSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;

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
		public function isObjectMatching(object:DisplayObject, matchers:Vector.<ParsedSelector>):Boolean {


			for each(var currentMatchers:ParsedSelector in matchers) {
				_currentlyMatchedMatchers = currentMatchers.matchers;
				_currentlyMatchedSelector = currentMatchers.selector;

				if (_currentlyMatchedMatchers.length == 0) {
					continue;
				}
				else {
					var isMatching:Boolean = reverseMatch(object, _currentlyMatchedMatchers.length - 1);
					//var isMatching:Boolean = reverseMatch(object, )
					if(isMatching) {
						return true;
					}
				}
			}

			return false;

		}



		private function reverseMatch(subject:DisplayObject, nextMatcher:int):Boolean {


			if (!subject) {
				return false;
			}



			var retryParent:Boolean = false;
			if (currentMatcherIsChildMatcher(nextMatcher)) {
				nextMatcher--;
			}

			if (currentMatcherIsDescendantMatcher(nextMatcher)) {
				nextMatcher--;
				retryParent = true;
			}



			for (var i:int = nextMatcher; i >= 0; --i) {
				var matcher:IMatcher = _currentlyMatchedMatchers[i];

				if (!matcher.isMatching(subject)) {
					return false;
				}

				if (matcher is ICombinator) {
					break;
				}
			}



			if (subject == _rootObject) {
				return false;
			}

			var result:Boolean;
			if (i >= 0 && retryParent) { //TODO (arneschroppe 6/2/12) specifically test this line!
				result = reverseMatch(subject.parent, nextMatcher);

				return result;
			}


			if (i < 0) {

				return true;
			}


			result = reverseMatch(subject.parent, i);
			return result;
		}


		private function currentMatcherIsChildMatcher(currentIndex:int):Boolean {
			return _currentlyMatchedMatchers[currentIndex] is ChildSelectorMatcher;
		}

		private function currentMatcherIsDescendantMatcher(currentIndex:int):Boolean {
			return _currentlyMatchedMatchers[currentIndex] is DescendantSelectorMatcher;
		}


	}
}
