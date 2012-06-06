package net.wooga.selectors.usagepatterns.implementations {

	import net.wooga.selectors.namespaces.selector_internal;
	import net.wooga.selectors.specificity.Specificity;
	import net.wooga.selectors.usagepatterns.*;

	use namespace selector_internal;

	public class SelectorDescriptionImpl implements SelectorDescription {
		private var _selectorString:String;
		private var _specificity:Specificity;
		private var _selectorGroupString:String;

		private var _pseudoElementName:String;




		public function set specificity(value:Specificity):void {
			_specificity = value;
		}

		public function get specificity():Specificity {
			return _specificity;
		}

		public function set selectorString(value:String):void {
			_selectorString = value;
		}

		public function get selectorString():String {
			return _selectorString;
		}

		public function set selectorGroupString(value:String):void {
			_selectorGroupString = value;
		}

		public function get selectorGroupString():String {
			return _selectorGroupString;
		}


		public function toString():String {
			return "[selector '" + _selectorString + "'" + ( (_selectorString == _selectorGroupString) ? " (selector group: '" + _selectorGroupString + "')" : "") + "]";
		}


		public function get isPseudoElementSelector():Boolean {
			return _pseudoElementName !== null;
		}


		public function get pseudoElementName():String {
			return _pseudoElementName;
		}

		public function set pseudoElementName(value:String):void {
			_pseudoElementName = value;
		}

	}
}
