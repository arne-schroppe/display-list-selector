package net.wooga.selectors.selectorstorage.keys {

	import flash.utils.Dictionary;

	import net.wooga.selectors.namespaces.selector_internal;

	import net.wooga.selectors.parser.FilterData;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;

	public class PseudoElementNameKey implements SelectorTreeNodeKey{

		use namespace selector_internal;
		
		private var _currentlyMatchedPseudoElement:String;

		public static const NULL_KEY:String = "*";

		public function set currentlyMatchedPseudoElement(value:String):void {
			_currentlyMatchedPseudoElement = value;
		}

		public function keyForSelector(parsedSelector:SelectorImpl, filterData:FilterData):String {
			return parsedSelector.pseudoElementName !== null ? parsedSelector.pseudoElementName : NULL_KEY;
		}

		public function selectorHasKey(parsedSelector:SelectorImpl, filterData:FilterData):Boolean {
			return parsedSelector.pseudoElementName !== null;
		}

		public function keysForAdapter(adapter:SelectorAdapter, nodes:Dictionary):Array {
			return [_currentlyMatchedPseudoElement];
		}

		public function get nullKey():String {
			return NULL_KEY;
		}

		public function invalidateCaches():void {
		}
	}
}
