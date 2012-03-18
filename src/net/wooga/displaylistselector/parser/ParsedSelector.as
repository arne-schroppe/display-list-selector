package net.wooga.displaylistselector.parser {
	import net.wooga.displaylistselector.ISpecificity;
	import net.wooga.displaylistselector.matching.matchers.IMatcher;

	public class ParsedSelector {
		private var _normalizedSelectorString:String;
		private var _originalSelectorString:String;
		private var _matchers:Vector.<IMatcher> = new <IMatcher>[];
		private var _specificity:ISpecificity;
		private var _filterData:FilterData = new FilterData();


		public function set normalizedSelectorString(value:String):void {
			_normalizedSelectorString = value;
		}

		public function get normalizedSelectorString():String {
			return _normalizedSelectorString;
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

		public function get originalSelectorString():String {
			return _originalSelectorString;
		}

		public function set originalSelectorString(value:String):void {
			_originalSelectorString = value;
		}

		//TODO (arneschroppe 14/3/12) it might be good to get rid of this object
		public function get filterData():FilterData {
			return _filterData;
		}

	}
}
