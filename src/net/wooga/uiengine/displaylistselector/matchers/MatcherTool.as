package net.wooga.uiengine.displaylistselector.matchers {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import net.wooga.uiengine.displaylistselector.matchers.implementations.ChildSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.DescendantSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.selectorcomparator.SelectorComparator;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.Set;
	import org.as3commons.collections.SortedSet;
	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.ISet;

	public class MatcherTool {

		private var _matchedObjects:Set;
		private var _rootObject:DisplayObject;

		private var _currentlyMatchedMatchers:Vector.<IMatcher>;


		public function MatcherTool(rootObject:DisplayObject) {
			_rootObject = rootObject;
		}


//
//		public function objectHasChanged(object:DisplayObject):void {
//			var iterator:IIterator = _selectorToResultMap.keyIterator();
//			var selector:String;
//			var invalidResults:Array = [];
//
//			while (iterator.hasNext()) {
//				selector = iterator.next();
//				var result:Set = _selectorToResultMap.itemFor(selector);
//				if (result.has(object)) {
//					invalidResults.push(selector);
//				}
//			}
//
//			invalidResults.every(function (item:String, index:int, array:Array):void {
//				_selectorToResultMap.removeKey(item);
//			});
//		}


		//
		//
		//public function hasMatchersForSelector(selector:String):Boolean {
		//	return _selectorToMatcherMap.hasKey(selector);
		//}



		public function findMatchingObjects(matchers:Vector.<IMatcher>):Set {


			_matchedObjects = new Set();
			_currentlyMatchedMatchers = matchers;

			match(_rootObject, new <MatcherPointer>[]);


			return _matchedObjects;
		}


		private function match(currentObject:DisplayObject, runningMatcherPointers:Vector.<MatcherPointer>):void {


			if (_currentlyMatchedMatchers.length == 0) {
				_matchedObjects.add(currentObject);
			}
			else {
				var newRunningMatcherPointers:Vector.<MatcherPointer> = applyMatchers(currentObject, runningMatcherPointers);
			}

			if (currentObject is DisplayObjectContainer) {
				matchChildren(currentObject as DisplayObjectContainer, newRunningMatcherPointers);
			}
		}

		private function applyMatchers(subject:DisplayObject, runningMatcherPointers:Vector.<MatcherPointer>):Vector.<MatcherPointer> {

			var matcherPointer:MatcherPointer = new MatcherPointer();
			return matchAllMatcherPointers(subject, (new <MatcherPointer>[matcherPointer]).concat(runningMatcherPointers) as Vector.<MatcherPointer>);
		}


		private function matchAllMatcherPointers(subject:DisplayObject, runningMatcherPointers:Vector.<MatcherPointer>):Vector.<MatcherPointer> {

			var newRunningMatcherPointers:Vector.<MatcherPointer> = new <MatcherPointer>[];
			for each(var pointer:MatcherPointer in runningMatcherPointers) {
				matchMatchers(subject, pointer, newRunningMatcherPointers);
			}

			//_objectToMatcherPointersMap.addOrReplace(subject, _currentlyMatchedSelector, newRunningMatcherPointers);

			return newRunningMatcherPointers;
		}


		private function matchMatchers(subject:DisplayObject, originalMatcherPointer:MatcherPointer, newRunningMatcherPointers:Vector.<MatcherPointer>):void {

			var matcherPointer:MatcherPointer = originalMatcherPointer.clone();
			var didNotMatch:Boolean = false;

			if (currentMatcherIsChildMatcher(matcherPointer.nextMatcher)) {
				matcherPointer.nextMatcher++;
			}

			if (currentMatcherIsDescendantMatcher(matcherPointer.nextMatcher)) {
				matcherPointer.nextMatcher++;

				//Also match this part of the matchers with all subsequent elements
				newRunningMatcherPointers.push(originalMatcherPointer);
			}


			var currentMatcher:IMatcher;
			for (; matcherPointer.nextMatcher < _currentlyMatchedMatchers.length; ++matcherPointer.nextMatcher) {

				currentMatcher = _currentlyMatchedMatchers[matcherPointer.nextMatcher];
				if (currentMatcher is ICombinator) {
					//will be handled in child elements
					break;
				}

				if (!currentMatcher.isMatching(subject)) {
					didNotMatch = true;
					break;
				}
			}

			if (didNotMatch) {
				//don't add to new matcher pointers
			}
			else if (matcherPointer.nextMatcher == _currentlyMatchedMatchers.length) {
				_matchedObjects.add(subject);
			}
			else {
				newRunningMatcherPointers.push(matcherPointer);
			}
		}


		private function currentMatcherIsChildMatcher(currentIndex:int):Boolean {
			return _currentlyMatchedMatchers[currentIndex] is ChildSelectorMatcher;
		}

		private function currentMatcherIsDescendantMatcher(currentIndex:int):Boolean {
			return _currentlyMatchedMatchers[currentIndex] is DescendantSelectorMatcher;
		}


		private function matchChildren(container:DisplayObjectContainer, runningMatcherPointers:Vector.<MatcherPointer>):void {

			for (var i:int = 0; i < container.numChildren; ++i) {
				match(container.getChildAt(i), runningMatcherPointers);
			}
		}



		//TODO (arneschroppe 9/1/12) write a test for this!!!!!!
		public function isObjectMatching(object:DisplayObject, matchers:Vector.<IMatcher>):Boolean {


			_currentlyMatchedMatchers = matchers

			if (_currentlyMatchedMatchers.length == 0) {
				return true
			}
			else {
				return reverseMatch(object, _currentlyMatchedMatchers.length - 1);
			}
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


			if (retryParent) {
				reverseMatch(subject.parent, nextMatcher);
			}
			else if (subject == _rootObject) {
				return false;
			}

			if (i < 0) {
				return true;
			}

			return reverseMatch(subject.parent, i);
		}


	}
}

class MatcherPointer {
	public var nextMatcher:int = 0;

	public function clone():MatcherPointer {
		var clonedObject:MatcherPointer = new MatcherPointer();
		clonedObject.nextMatcher = nextMatcher;
		return clonedObject;
	}
}
