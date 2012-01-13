package net.wooga.uiengine.displaylistselector.parser {
	import net.wooga.uiengine.displaylistselector.matchers.IMatcher;

	public class ParserResult {
		private var _matchers:Vector.<IMatcher>;
		private var _specificity:Number;

		public function ParserResult(matchers:Vector.<IMatcher>, specificity:Number) {
			_matchers = matchers;
			_specificity = specificity;
		}

		public function get matchers():Vector.<IMatcher> {
			return _matchers;
		}

		public function get specificity():Number {
			return _specificity;
		}


	}
}
