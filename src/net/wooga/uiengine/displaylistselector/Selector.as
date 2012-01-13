package net.wooga.uiengine.displaylistselector {
	import net.wooga.uiengine.displaylistselector.matchers.IMatcher;

	import org.as3commons.collections.Set;

	public class Selector {

		private var _selectorString:String;
		private var _context:SelectorContext;
		
		private var _matchers:Vector.<IMatcher>;
		private var _matchedObjects:Set;
		
		private var _specificity:Number;

		public function Selector(selectorString:String, context:SelectorContext=DefaultSelectorContext) {
			_selectorString = selectorString;
			_context = context;
		}

		public function get selectorString():String {
			return _selectorString;
		}

		public function getMatches():Set {

			if(_matchedObjects) {
				return _matchedObjects;
			}

			_matchedObjects = _context.matcherTool.findMatchingObjects(_matchers);

			return _matchedObjects;
		}


		public function get specificity():Number {
			return _specificity;
		}
	}
}
