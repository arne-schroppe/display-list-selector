package net.wooga.uiengine.displaylistselector.parser {
	import net.wooga.uiengine.displaylistselector.ISpecificity;
	import net.wooga.uiengine.displaylistselector.matching.matchers.IMatcher;

	public class ParsedSelector {
		private var _selector:String;
		private var _originalSelector:String;
		private var _matchers:Vector.<IMatcher> = new <IMatcher>[];
		private var _specificity:ISpecificity;
		private var _filterData:FilterData = new FilterData();


		public function set selector(value:String):void {
			_selector = value;
		}

		public function get selector():String {
			return _selector;
		}

		public function get specificity():ISpecificity {
			return _specificity;
		}

		public function set specificity(value:ISpecificity):void {
			_specificity = value;
		}


		public function get matchers():Vector.<IMatcher> {
			return _matchers;
		}

		public function get originalSelector():String {
			return _originalSelector;
		}

		public function set originalSelector(value:String):void {
			_originalSelector = value;
		}

		public function get filterData():FilterData {
			return _filterData;
		}

	}
}
