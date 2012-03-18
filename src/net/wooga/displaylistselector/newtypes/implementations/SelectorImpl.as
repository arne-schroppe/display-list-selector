package net.wooga.displaylistselector.newtypes.implementations {

	import net.wooga.displaylistselector.ISpecificity;
	import net.wooga.displaylistselector.matching.MatcherTool;
	import net.wooga.displaylistselector.newtypes.*;
	import net.wooga.displaylistselector.parser.ParsedSelector;
	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

	import org.as3commons.collections.framework.IMap;

	public class SelectorImpl extends SelectorDescriptionImpl implements Selector {
		private var _parsedSelector:ParsedSelector;
		private var _objectToStyleAdapterMap:IMap;
		private var _matcher:MatcherTool;



		public function SelectorImpl(selectorString:String, specificity:ISpecificity, originalSelector:String, matcher:MatcherTool, objectToStyleAdapterMap:IMap, parsedSelector:ParsedSelector) {
			super(selectorString, specificity, originalSelector);
			_matcher = matcher;
			_objectToStyleAdapterMap = objectToStyleAdapterMap;
			_parsedSelector = parsedSelector;
		}


		public function isMatching(object:Object):Boolean {
			var adapter:ISelectorAdapter = _objectToStyleAdapterMap.itemFor(object);
			if(!adapter) {
				throw new ArgumentError("No style adapter registered for object " + object);
			}

			return _matcher.isObjectMatching(adapter, _parsedSelector);
		}
	}
}
