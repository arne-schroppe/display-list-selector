package net.wooga.uiengine.displaylistselector.parser {
	import net.wooga.uiengine.displaylistselector.ISpecificity;
	import net.wooga.uiengine.displaylistselector.matchers.IMatcher;

	public class ParserResult {
		private var _matchers:Vector.<IMatcher>;
		private var _specificity:ISpecificity;

		public function ParserResult(matchers:Vector.<IMatcher>, specificity:ISpecificity) {
			_matchers = matchers;
			_specificity = specificity;
		}

		public function get matchers():Vector.<IMatcher> {
			return _matchers;
		}

		public function get specificity():ISpecificity {
			return _specificity;
		}


	}
}
