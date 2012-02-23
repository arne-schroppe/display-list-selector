package net.wooga.uiengine.displaylistselector.parser {
	import net.wooga.uiengine.displaylistselector.matching.matchers.IMatcher;

	public class ParsedSelector {
		private var _selector:String;
		private var _matchers:Vector.<IMatcher> = new <IMatcher>[];


		public function set selector(value:String):void {
			_selector = value;
		}

		public function get selector():String {
			return _selector;
		}

		public function get matchers():Vector.<IMatcher> {
			return _matchers;
		}

	}
}
