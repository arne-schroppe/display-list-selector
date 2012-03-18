package net.wooga.displaylistselector.newtypes.implementations {

	import net.wooga.displaylistselector.ISpecificity;
	import net.wooga.displaylistselector.newtypes.*;

	public class SelectorDescriptionImpl implements SelectorDescription {
		private var _selectorString:String;
		private var _specificity:ISpecificity;
		private var _originalSelectorString:String;


		public function set selectorString(value:String):void {
			_selectorString = value;
		}

		public function set specificity(value:ISpecificity):void {
			_specificity = value;
		}

		public function set originalSelectorString(value:String):void {
			_originalSelectorString = value;
		}


		public function get specificity():ISpecificity {
			return _specificity;
		}

		public function get selectorString():String {
			return _selectorString;
		}

		public function get originalSelectorString():String {
			return _originalSelectorString;
		}
	}
}
