package net.wooga.uiengine.displaylistselector.matching {
	import net.wooga.uiengine.displaylistselector.matching.matchers.ICombinator;
	import net.wooga.uiengine.displaylistselector.matching.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.ChildSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.DescendantSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	import org.as3commons.collections.framework.IMap;

	public class MatcherTool {

		private var _rootObject:Object;

		private var _currentlyMatchedMatchers:Vector.<IMatcher>;
		private var _currentlyMatchedSelector:String;
		private var _objectToAdapterMap:IMap;

		public function MatcherTool(rootObject:Object, objectToAdapterMap:IMap) {
			_rootObject = rootObject;
			_objectToAdapterMap = objectToAdapterMap;
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
				return result;
			}


			if (i < 0) {
				return true;
			}

			result = reverseMatchParentIfPossible(subject, i);
			return result;
		}

		private function reverseMatchParentIfPossible(subject:IStyleAdapter, nextMatcher:int):Boolean {

			//TODO (arneschroppe 22/2/12) we should use a isObjectEqualTo-method here
			if (subject.getAdaptedElement() == _rootObject) {
				return false;
			}

			return reverseMatch(_objectToAdapterMap.itemFor(subject.getParentElement()), nextMatcher);
		}


		private function currentMatcherIsChildMatcher(currentIndex:int):Boolean {
			return _currentlyMatchedMatchers[currentIndex] is ChildSelectorMatcher;
		}

		private function currentMatcherIsDescendantMatcher(currentIndex:int):Boolean {
			return _currentlyMatchedMatchers[currentIndex] is DescendantSelectorMatcher;
		}


	}
}
