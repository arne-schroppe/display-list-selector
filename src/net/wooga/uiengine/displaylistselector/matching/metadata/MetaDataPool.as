package net.wooga.uiengine.displaylistselector.matching.metadata {
	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.matching.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.ChildSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.DescendantSelectorMatcher;
	import net.wooga.uiengine.displaylistselector.matching.metadata.MatcherMetaData;
	import net.wooga.uiengine.displaylistselector.tools.MultiMap;

	import org.as3commons.collections.Map;

	public class MetaDataPool {

		private var _rootObject:DisplayObject;


		private var _objectMetaData:MultiMap = new MultiMap(3); //DisplayObject -> String (selector) -> MatcherMetaData


		private var _objectSubMetaData:MultiMap = new MultiMap(3)

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


				_currentSubject = object;
				_position = matchers.length;
				_currentSelector = selector;
				buildMatcherList(copyVector(matchers));

				metaData = _currentData;

				_objectMetaData.addOrReplace(object, selector, metaData);
			}

			return metaData.isMatching();
		}

		private function copyVector(matchers:Vector.<IMatcher>):Vector.<IMatcher> {
			return matchers.concat();
		}



		private function buildMatcherList(matchers:Vector.<IMatcher>):void {

			if(matchers.length == 0) {
				_currentData.isStartMatcher = true;
				return;
			}


			var retryParent:Boolean = false;
			var store:Boolean = false;
			var currentMatcher:IMatcher = matchers[matchers.length-1];

			if (currentMatcher is ChildSelectorMatcher) {

				if(!advanceToParentElement()) {
					return;
				}
				store = true;

				matchers.pop();
				_position--;
				currentMatcher = matchers[matchers.length-1];
			}
			else if (currentMatcher is DescendantSelectorMatcher) {
				retryParent = true;
				currentMatcher = matchers[matchers.length-2];
			}

			addMatcherStep(currentMatcher);
			
			if(store) {
				var key:String = _currentSelector + "??" + _position;
				trace(_currentSubject, key);
				_objectSubMetaData.addOrReplace(_currentSubject, key, _currentData);
				trace("new data");
			}

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

			trace("aaaa " + _currentSubject, key);
			var metaData:MatcherMetaData = _objectSubMetaData.itemFor(_currentSubject, key);
			if(metaData) {

				trace("Has meta data");

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
