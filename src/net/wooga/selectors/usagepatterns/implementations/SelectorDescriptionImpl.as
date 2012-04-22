package net.wooga.selectors.usagepatterns.implementations {

	import net.wooga.selectors.specificity.Specificity;
	import net.wooga.selectors.usagepatterns.*;

	public class SelectorDescriptionImpl implements SelectorDescription {
		private var _selectorString:String;
		private var _specificity:Specificity;
		private var _selectorGroupString:String;




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
	}
}
