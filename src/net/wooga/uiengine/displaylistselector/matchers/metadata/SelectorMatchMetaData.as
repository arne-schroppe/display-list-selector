package net.wooga.uiengine.displaylistselector.matchers.metadata {
	import flash.display.DisplayObjectContainer;

	import net.wooga.uiengine.displaylistselector.matchers.IMatcher;

	public class SelectorMatchMetaData {

		private var _parentObject:DisplayObjectContainer;
		private var _matchers:Vector.<IMatcher>;
		private var _matcherPointer:int;
		private var _isValid:Boolean;
		private var _needsRematch:Boolean = true;

		public function get parentObject():DisplayObjectContainer {
			return _parentObject;
		}

		public function set parentObject(value:DisplayObjectContainer):void {
			_parentObject = value;
		}

		public function get matchers():Vector.<IMatcher> {
			return _matchers;
		}

		public function set matchers(value:Vector.<IMatcher>):void {
			_matchers = value;
		}

		public function get matcherPointer():int {
			return _matcherPointer;
		}

		public function set matcherPointer(value:int):void {
			_matcherPointer = value;
		}

		public function get isValid():Boolean {
			return _isValid;
		}

		public function set isValid(value:Boolean):void {
			_isValid = value;
		}


		public function get needsRematch():Boolean {
			return _needsRematch;
		}

		public function set needsRematch(value:Boolean):void {
			_needsRematch = value;
		}

	}
}
