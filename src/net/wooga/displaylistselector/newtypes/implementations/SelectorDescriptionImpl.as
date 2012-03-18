package net.wooga.displaylistselector.newtypes.implementations {

	import net.wooga.displaylistselector.ISpecificity;
	import net.wooga.displaylistselector.newtypes.*;

	public class SelectorDescriptionImpl implements SelectorDescription {
		private var _selectorString:String;
		private var _specificity:ISpecificity;
		private var _originalSelector:String;


		public function SelectorDescriptionImpl(selectorString:String, specificity:ISpecificity, originalSelector:String) {
			_selectorString = selectorString;
			_specificity = specificity;
			_originalSelector = originalSelector;
		}

		public function get specificity():ISpecificity {
			return _specificity;
		}

		public function get selectorString():String {
			return _selectorString;
		}

		public function get originalSelectorString():String {
			return _originalSelector;
		}
	}
}
