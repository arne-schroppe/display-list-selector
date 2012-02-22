package net.wooga.uiengine.displaylistselector.selector {
	import net.wooga.uiengine.displaylistselector.*;
	import net.wooga.uiengine.displaylistselector.selector.ISelector;

	public class Selector implements ISelector {

		private var _selectorString:String;


		//private var _matchers:Vector.<ParsedSelector>;
		//private var _matchedObjects:Set;

		private var _specificity:ISpecificity;



		use namespace selector_internal;

		public function Selector(selectorString:String, specificity:ISpecificity) {
			_selectorString = selectorString;
			_specificity = specificity;

		}


		public function get selectorString():String {
			return _selectorString;
		}


		public function get specificity():ISpecificity {
			return _specificity;
		}


		//TODO (arneschroppe 20/1/12) add queries on selectors?
	}
}
