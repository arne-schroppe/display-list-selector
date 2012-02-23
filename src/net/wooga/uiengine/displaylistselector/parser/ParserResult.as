package net.wooga.uiengine.displaylistselector.parser {
	import net.wooga.uiengine.displaylistselector.ISpecificity;

	//TODO (arneschroppe 23/2/12) merge this with parsedselector and use only that one
	public class ParserResult {
		private var _matchers:Vector.<ParsedSelector>;
		private var _specificity:ISpecificity;

		public function ParserResult(matchers:Vector.<ParsedSelector>, specificity:ISpecificity) {
			_matchers = matchers;
			_specificity = specificity;
		}

		public function get matchers():Vector.<ParsedSelector> {
			return _matchers;
		}

		public function get specificity():ISpecificity {
			return _specificity;
		}


	}
}
