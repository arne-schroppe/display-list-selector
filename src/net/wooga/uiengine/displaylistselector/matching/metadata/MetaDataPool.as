package net.wooga.uiengine.displaylistselector.matching.metadata {
	import flash.debugger.enterDebugger;
	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.matching.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.ChildSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.DescendantSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matching.metadata.MatcherMetaData;
	import net.wooga.uiengine.displaylistselector.tools.MultiMap;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.Set;
	import org.as3commons.collections.framework.IIterator;

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

		
		private function traceExpression(text:Object, val:*):* {
			trace(text + val);
			return val;
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


			var retryParent:Boolean = false;
			var currentMatcher:IMatcher = matchers[matchers.length-1];

			var storeStep:Boolean = false;
			if (currentMatcher is ChildSelectorMatcher) {

				if(!advanceToParentElement()) {
					return;
				}
				storeStep = true;
				

				matchers.pop();
				_position--;
				currentMatcher = matchers[matchers.length-1];
			}
			else if (currentMatcher is DescendantSelectorMatcher) {
				retryParent = true;
				currentMatcher = matchers[matchers.length-2];
				//TODO (arneschroppe 8/2/12) handle key storage in this case
			}

			addMatcherStep(currentMatcher);


			if(!currentMatcher.isMatching(_currentSubject)) {
				if(retryParent) {

					if(!advanceToParentElement()) {
						return;
					}
					buildMatcherList(matchers);
				}

				return;
			}

			if(retryParent) {
				//pop descendant selector
				matchers.pop();
				_position--;
			}

			if(storeStep) {
				var key:String = _currentSelector + "??" + _position;
				//trace("Should store step for " + _currentSubject + " " + key);
				//enterDebugger();
				_objectSubMetaData.addOrReplace(_currentSubject, key, _currentData);
			}

			matchers.pop();
			_position--;

			buildMatcherList(matchers);
		}


		private function advanceToParentElement():Boolean {
			if(_currentSubject == _rootObject) {
				return false;
			}

			_currentSubject = _currentSubject.parent;

			if(_currentSubject == null) {
				return false;
			}



			var key:String = _currentSelector + "??" + (_position - 1);

			//trace("retrieving " + _currentSubject + " " + key);
			var metaData:MatcherMetaData = _objectSubMetaData.itemFor(_currentSubject, key);
			//enterDebugger();
			if(metaData) {

				//trace("Has meta data");

				_currentData.parentMatcher = metaData;
				return false;
			}

			return true;
		}

		
		private function addMatcherStep(currentMatcher:IMatcher):void {




			var metaData:MatcherMetaData;

			metaData = new MatcherMetaData(currentMatcher);
			metaData.subject = _currentSubject;

			var storedMatchers:Set =_objectToMatcherMetaDataMap.itemFor(_currentSubject);
			if(!storedMatchers) {
				storedMatchers = new Set();
				_objectToMatcherMetaDataMap.add(_currentSubject, storedMatchers);
			}

			storedMatchers.add(metaData);

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
