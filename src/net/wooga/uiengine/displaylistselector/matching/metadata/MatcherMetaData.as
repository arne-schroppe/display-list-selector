package net.wooga.uiengine.displaylistselector.matching.metadata {
	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.matching.matchers.IMatcher;

	public class MatcherMetaData {


		private var _subject:DisplayObject;

		private var _matcher:IMatcher;
		private var _needsRematch:Boolean = true;
		private var _isMatching:Boolean = false;

		private var _parentMatcher:MatcherMetaData;

		public function MatcherMetaData(matcher:IMatcher) {
			_matcher = matcher;
		}

		private var _isStartMatcher:Boolean;

		public function set subject(value:DisplayObject):void {
			_subject = value;
		}


		public function set parentMatcher(value:MatcherMetaData):void {
			_parentMatcher = value;
		}

		//private var _nextMatchers:Vector.<MatcherMetaData>;

		public function isMatching():Boolean {

			if(_needsRematch) {
				_isMatching = _matcher.isMatching(_subject) && areAllPreviousMatchersMatching;
				_needsRematch = false;
			}

			return _isMatching;
		}


		private function get areAllPreviousMatchersMatching():Boolean {
			if(!_parentMatcher) {
				return _isStartMatcher;
			}
			else {
				//TODO (arneschroppe 7/2/12) cache this
				return _parentMatcher.isMatching();
			}
		}


		public function set isStartMatcher(value:Boolean):void {
			_isStartMatcher = value;
		}
	}
}
