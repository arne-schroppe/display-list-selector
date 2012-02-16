package net.wooga.uiengine.displaylistselector.matching.old.metadata {
	import flash.debugger.enterDebugger;
	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.matching.old.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.implementations.ChildSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.implementations.DescendantSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matching.old.metadata.MatcherMetaData;
	import net.wooga.uiengine.displaylistselector.tools.MultiMap;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.IIterator;
	import org.flexunit.asserts.fail;
	import org.hamcrest.object.isFalse;

	public class MetaDataPool {

		private var _rootObject:DisplayObject;


		private var _objectMetaData:MultiMap = new MultiMap(2); //DisplayObject -> String (selector) -> MatcherMetaData


		private var _objectSubMetaData:MultiMap = new MultiMap(2);

		private var _objectToMatcherMetaDataMap:Map = new Map();

		//private var _selectorToMatcherMap:Map = new Map();
		
		private var _currentSubject:DisplayObject;
		private var _currentData:MatcherMetaData;
		private var _position:int;
		private var _currentSelector:String;

		public function isMatching(object:DisplayObject, selector:String, matchers:Vector.<IMatcher>):Boolean {
			//
			//if(!_selectorToMatcherMap.hasKey(selector)) {
			//	_selectorToMatcherMap.add(selector, matchers);
			//}
			
			var metaData:MatcherMetaData = _objectMetaData.itemFor(object, selector);
			if(!metaData) {


				//trace("===== Building matcher list for " + object);
				
				_currentSubject = object;
				_position = matchers.length;
				_currentSelector = selector;
				buildMatcherList(copyVector(matchers));

				metaData = _currentData;

				_objectMetaData.addOrReplace(object, selector, metaData);
				
				//trace(" +++++++++++++++  ")
			}

			return metaData.isMatching(); //traceExpression("Result: ", metaData.isMatching());
		}

		public function invalidate(object:DisplayObject):void {
			var metaDataSet:Set = _objectToMatcherMetaDataMap.itemFor(object);
			if(!metaDataSet) {
				return;
			}

			var iterator:IIterator = metaDataSet.iterator();
			while(iterator.hasNext()) {
				var meta:MatcherMetaData = iterator.next();
				meta.invalidate();
			}
		}



		private function copyVector(matchers:Vector.<IMatcher>):Vector.<IMatcher> {
			return matchers.concat();
		}



		private function buildMatcherList(matchers:Vector.<IMatcher>):void {

			if(matchers.length == 0) {
				//trace("reached start matcher " + _currentData.subject);
				_currentData.isStartMatcher = true;
				return;
			}

			var currentMatcher:IMatcher = matchers[matchers.length-1];

			if (currentMatcher is ChildSelectorMatcher) {
				handleChildSelector(matchers);
			}
			else if (currentMatcher is DescendantSelectorMatcher) {
				handleDescendantMatcher(matchers);
			}
			else {
				if(!handleMatcher(matchers)) {
					return;
				}

				buildMatcherList(matchers);
			}
		}


		private function handleDescendantMatcher(matchers:Vector.<IMatcher>):void {

			advanceMatchers(matchers);
			while(true) {

				if(!advanceToParentElement()) {
					return;
				}

				if(handleMatcher(matchers)) {
					break;
				}
			}

			cacheStep();
			buildMatcherList(matchers);

		}


		private function handleChildSelector(matchers:Vector.<IMatcher>):void {

			advanceMatchers(matchers);

			if(!advanceToParentElementAndAbortIfCachedVersionExists()) {
				return;
			}

			if(!handleMatcher(matchers)) {
				return;
			}

			cacheStep();
			buildMatcherList(matchers);

		}


		private function handleMatcher(matchers:Vector.<IMatcher>):Boolean {
			var currentMatcher:IMatcher = matchers[matchers.length-1];

			addMatcherStep(currentMatcher);

			if(!currentMatcher.isMatching(_currentSubject)) {
				return false;
			}

			advanceMatchers(matchers);
			return true;
		}


		private function advanceMatchers(matchers:Vector.<IMatcher>):void {
			matchers.pop();
			_position--;
		}


		private function cacheStep():void {
			var key:String = _currentSelector + "??" + _position;
			_objectSubMetaData.addOrReplace(_currentSubject, key, _currentData);
		}


		private function advanceToParentElement():Boolean {
			if(_currentSubject == _rootObject) {
				return false;
			}

			_currentSubject = _currentSubject.parent;

			if(_currentSubject == null) {
				return false;
			}

			return true;
		}
		
		
		private function advanceToParentElementAndAbortIfCachedVersionExists():Boolean {
			
			if(!advanceToParentElement()) {
				return false;
			}
			
			var key:String = _currentSelector + "??" + (_position - 1);

			var metaData:MatcherMetaData = _objectSubMetaData.itemFor(_currentSubject, key);
			if(metaData) {
				_currentData.parentMatcher = metaData;
				return false;
			}

			return true;
		}

		
		private function addMatcherStep(currentMatcher:IMatcher):void {

			var metaData:MatcherMetaData;

			metaData = new MatcherMetaData(currentMatcher);
			metaData.subject = _currentSubject;

			if (_currentData) {
				_currentData.parentMatcher = metaData;
			}

			_currentData = metaData;
		}



		public function set rootObject(value:DisplayObject):void {
			_rootObject = value;
		}
	}
}
