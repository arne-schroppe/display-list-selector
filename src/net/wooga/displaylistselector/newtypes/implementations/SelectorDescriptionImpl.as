package net.wooga.displaylistselector.newtypes.implementations {

	import net.wooga.displaylistselector.ISpecificity;
	import net.wooga.displaylistselector.newtypes.*;

	public class SelectorDescriptionImpl implements SelectorDescription {
		private var _selectorString:String;
		private var _specificity:ISpecificity;


		public function SelectorDescriptionImpl(selectorString:String, specificity:ISpecificity) {
			_selectorString = selectorString;
			_specificity = specificity;
		}

		public function get specificity():ISpecificity {
			return _specificity;
		}

		public function get selectorString():String {
			return _selectorString;
		}
	}
}
