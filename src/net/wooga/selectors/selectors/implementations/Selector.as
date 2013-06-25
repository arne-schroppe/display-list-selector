package net.wooga.selectors.selectors.implementations {

	import net.wooga.selectors.adaptermap.ISelectorAdapterSource;
	import net.wooga.selectors.matching.MatcherTool;
	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.namespace.selector_internal;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;
	import net.wooga.selectors.selectors.*;
	import net.wooga.selectors.specificity.ISpecificity;

	use namespace selector_internal;

	public class Selector implements ISelector {

		private var _selectorString:String;
		private var _specificity:ISpecificity;
		private var _selectorGroupString:String;

		private var _pseudoElementName:String;

		private var _adapterSource:ISelectorAdapterSource;
		private var _matcherTool:MatcherTool;
		private var _matchers:Vector.<IMatcher> = new <IMatcher>[];


		public function set specificity(value:ISpecificity):void {
			_specificity = value;
		}

		public function get specificity():ISpecificity {
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



		public function isMatching(object:Object):Boolean {
			var adapter:ISelectorAdapter = _adapterSource.getSelectorAdapterForObject(object);
			if(!adapter) {
				throw new ArgumentError("No selector adapter registered for object " + object);
			}

			return _matcherTool.isObjectMatching(adapter, _matchers);
		}



		selector_internal function set adapterMap(value:ISelectorAdapterSource):void {
			_adapterSource = value;
		}

		selector_internal function set matcherTool(value:MatcherTool):void {
			_matcherTool = value;
		}


		selector_internal function set matchers(value:Vector.<IMatcher>):void {
			_matchers = value;
		}

		selector_internal function get matchers():Vector.<IMatcher> {
			return _matchers;
		}


	}
}
