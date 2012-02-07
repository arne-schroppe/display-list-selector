package net.wooga.uiengine.displaylistselector.matching {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import net.wooga.uiengine.displaylistselector.matching.matchers.ICombinator;

	import net.wooga.uiengine.displaylistselector.matching.matchers.IMatcher;

	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.ChildSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.DescendantSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matching.metadata.MatchMetaData;
	import net.wooga.uiengine.displaylistselector.matching.metadata.SelectorMatchMetaData;
	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.IIterator;

	public class MatcherTool {

		private var _matchedObjects:Set;
		private var _rootObject:DisplayObject;

		private var _currentlyMatchedMatchers:Vector.<IMatcher>;
		private var _currentlyMatchedSelector:String;

		private var _objectToMetaDataMap:Map = new Map();

		public function MatcherTool(rootObject:DisplayObject) {
			_rootObject = rootObject;
		}




		public function findMatchingObjects(matchers:Vector.<ParsedSelector>):Set {

			_matchedObjects = new Set();

			for each(var currentMatcherSet:ParsedSelector in matchers) {
				_currentlyMatchedMatchers = currentMatcherSet.matchers;
				_currentlyMatchedSelector = currentMatcherSet.selector;

				match(_rootObject, new <MatcherPointer>[]);
			}

			return _matchedObjects;
		}


		private function match(currentObject:DisplayObject, runningMatcherPointers:Vector.<MatcherPointer>):void {


			if (_currentlyMatchedMatchers.length == 0) {
				trace("MATCHER matches " + currentObject);
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
				trace("MATCHER matches " + subject);
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



		public function invalidateObject(object:DisplayObject):void {
			var metaData:MatchMetaData = _objectToMetaDataMap.itemFor(object);
			if(metaData == null) {
				return;
			}

			trace("Object was invalidated: " + object);

			var iterator:IIterator = metaData.selectorToMetaDataMap.iterator();
			while(iterator.hasNext()) {
				var selectorMetaData:SelectorMatchMetaData = iterator.next();
				selectorMetaData.needsRematch = true;
			}

			//TODO (arneschroppe 6/2/12) selector-children might also need rematch
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
					if(isMatching) {
						return true;
					}
				}
			}

			return false;
		}


		private function selectorMetaDataForObject(object:DisplayObject, nextMatcher:int):SelectorMatchMetaData {
			var metaData:MatchMetaData = metaDataForObject(object);

			var key:String = selectorAndPositionKey(nextMatcher);

			var selectorMetaData:SelectorMatchMetaData = metaData.selectorToMetaDataMap.itemFor(key);
			if(selectorMetaData == null) {
				selectorMetaData = new SelectorMatchMetaData();
				metaData.selectorToMetaDataMap.add(key, selectorMetaData);
			}

			return selectorMetaData;
		}

		private function selectorAndPositionKey(nextMatcher:int):String {
			return _currentlyMatchedSelector + "??" + nextMatcher;
		}
		

		private function metaDataForObject(object:DisplayObject):MatchMetaData {
			var metaData:MatchMetaData = _objectToMetaDataMap.itemFor(object);
			if(metaData == null) {
				metaData = new MatchMetaData();
				_objectToMetaDataMap.add(object, metaData);
			}

			return metaData;
		}


		private function reverseMatch(subject:DisplayObject, nextMatcher:int):Boolean {


			if (!subject) {
				return false;
			}

			
			var selectorMetaData:SelectorMatchMetaData = selectorMetaDataForObject(subject, nextMatcher);
			
			if(!selectorMetaData.needsRematch) {
				return selectorMetaData.isMatching;
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
					selectorMetaData.isMatching = false;
					selectorMetaData.needsRematch = false;
					return false;
				}

				if (matcher is ICombinator) {
					break;
				}
			}





			if (subject == _rootObject) {
				selectorMetaData.isMatching = false;
				selectorMetaData.needsRematch = false;
				return false;
			}

			var result:Boolean;
			if (i >= 0 && retryParent) { //TODO (arneschroppe 6/2/12) specifically test this line!
				result = reverseMatch(subject.parent, nextMatcher);
				selectorMetaData.isMatching = result;
				selectorMetaData.needsRematch = false;
				return result;
			}


			if (i < 0) {
				selectorMetaData.isMatching = true;
				selectorMetaData.needsRematch = false;
				return true;
			}


			result = reverseMatch(subject.parent, i);
			selectorMetaData.isMatching = result;
			selectorMetaData.needsRematch = false;
			return result;
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
