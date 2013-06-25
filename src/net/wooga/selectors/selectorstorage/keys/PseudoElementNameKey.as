package net.wooga.selectors.selectorstorage.keys {

	import flash.utils.Dictionary;

	import net.wooga.selectors.namespace.selector_internal;

	import net.wooga.selectors.parser.FilterData;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;
	import net.wooga.selectors.selectors.implementations.Selector;

	public class PseudoElementNameKey implements ISelectorTreeNodeKey{

		use namespace selector_internal;
		
		private var _currentlyMatchedPseudoElement:String;

		public static const NULL_KEY:String = "*";

		public function set currentlyMatchedPseudoElement(value:String):void {
			_currentlyMatchedPseudoElement = value;
		}

		public function keyForSelector(parsedSelector:Selector, filterData:FilterData):String {
			return parsedSelector.pseudoElementName !== null ? parsedSelector.pseudoElementName : NULL_KEY;
		}

		public function selectorHasKey(parsedSelector:Selector, filterData:FilterData):Boolean {
			return parsedSelector.pseudoElementName !== null;
		}

		public function keysForAdapter(adapter:ISelectorAdapter, nodes:Dictionary):Array {
			return [_currentlyMatchedPseudoElement];
		}

		public function get nullKey():String {
			return NULL_KEY;
		}

		public function invalidateCaches():void {
		}
	}
}
