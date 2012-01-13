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

	public class Matchers {

		private var _matchedObjects:Set;
		private var _rootObject:DisplayObject;
		private var _selectorToMatcherMap:Map = new Map();


		private var _currentlyMatchedMatchers:Vector.<IMatcher>;
		private var _currentlyMatchedSelector:String;

		private var _selectorToResultMap:Map = new Map();
		
		private var _matchedSelectors:ISet;
		private var _knownSelectors:ISet = new Set();

		public function Matchers(rootObject:DisplayObject) {
			_rootObject = rootObject;
		}


		public function findMatchesFor(selector:String):Set {
			if (_selectorToResultMap.hasKey(selector)) {
				return _selectorToResultMap.itemFor(selector);
			}
			else {
				var matchers:Vector.<IMatcher>;
				matchers = _selectorToMatcherMap.itemFor(selector);
				return findMatches(matchers, selector);
			}
		}


		public function objectHasChanged(object:DisplayObject):void {
			var iterator:IIterator = _selectorToResultMap.keyIterator();
			var selector:String;
			var invalidResults:Array = [];

			while (iterator.hasNext()) {
				selector = iterator.next();
				var result:Set = _selectorToResultMap.itemFor(selector);
				if (result.has(object)) {
					invalidResults.push(selector);
				}
			}

			invalidResults.every(function (item:String, index:int, array:Array):void {
				_selectorToResultMap.removeKey(item);
			});
		}


		public function hasMatchersForSelector(selector:String):Boolean {
			return _selectorToMatcherMap.hasKey(selector);
		}


		public function setMatchersForSelector(selector:String, matchers:Vector.<IMatcher>):void {
			_selectorToMatcherMap.add(selector, matchers);
			_knownSelectors.add(selector);
		}


		private function findMatches(matchers:Vector.<IMatcher>, selector:String):Set {


			_matchedObjects = new Set();

			_currentlyMatchedMatchers = matchers;
			_currentlyMatchedSelector = selector;
			match(_rootObject, new <MatcherPointer>[]);

			_selectorToResultMap.add(selector, _matchedObjects);


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


		public function getSelectorsMatchingObject(displayObject:DisplayObject, selectors:IIterable, comparator:SelectorComparator):ISet {
			_matchedSelectors = new SortedSet(comparator);
			reverseMatchSelectors(displayObject, selectors.iterator());
			return _matchedSelectors;
		}


		/*
		private function reverseMatchAllKnownSelectors(object:DisplayObject):void {
			reverseMatchSelectors(object, knownSelectors.iterator());
		}
		*/

		private function reverseMatchSelectors(object:DisplayObject, selectors:IIterator):void {

			while (selectors.hasNext()) {
				var selector:String = selectors.next();

				_currentlyMatchedSelector = selector;
				_currentlyMatchedMatchers = _selectorToMatcherMap.itemFor(selector);

				if(!_currentlyMatchedMatchers) {
					continue;
				}
				else if (_currentlyMatchedMatchers.length == 0) {
					addToResultSet(_currentlyMatchedSelector, object);
				}
				else {
					reverseMatch(object, _currentlyMatchedMatchers.length - 1, object);
				}
			}
		}


		private function addToResultSet(selector:String, object:DisplayObject):void {

			_matchedSelectors.add(selector);

			var results:Set = _selectorToResultMap.itemFor(selector);

			if (!results || results.has(object)) {
				return;
			}

			results.add(object);
		}

		//TODO (arneschroppe 9/1/12) write a test for this!!!!!!

		private function reverseMatch(subject:DisplayObject, nextMatcher:int, originalSubject:DisplayObject):void {

			if (!subject) {
				return;
			}

			var retryParent:Boolean = false;
			if (currentMatcherIsChildMatcher(nextMatcher)) {
				nextMatcher--;
			}

			if (currentMatcherIsDescendantMatcher(nextMatcher)) {
				nextMatcher--;
				retryParent = true;
			}


			var didNotMatch:Boolean = false;

			for (var i:int = nextMatcher; i >= 0; --i) {
				var matcher:IMatcher = _currentlyMatchedMatchers[i];

				if (!matcher.isMatching(subject)) {
					didNotMatch = true;
					return;
				}

				if (matcher is ICombinator) {
					break;
				}
			}


			if (didNotMatch) {

				if (retryParent) {
					reverseMatch(subject.parent, nextMatcher, originalSubject);
				}

				return;
			}
			else if (subject == _rootObject) {
				return;
			}

			if (i < 0) {
				addToResultSet(_currentlyMatchedSelector, originalSubject);
				return;
			}

			reverseMatch(subject.parent, i, originalSubject);
		}


		private function get knownSelectors():IIterable {
			return _knownSelectors;
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
