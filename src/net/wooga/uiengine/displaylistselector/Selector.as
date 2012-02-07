package net.wooga.uiengine.displaylistselector {

	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.matching.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.parser.ParserResult;

	import org.as3commons.collections.Set;

	public class Selector {

		private var _selectorString:String;
		private var _context:SelectorContext;


		private var _matchers:Vector.<ParsedSelector>;
		private var _matchedObjects:Set;

		private var _specificity:ISpecificity;

		public static const USE_DEFAULT_CONTEXT:SelectorContext = null;


		use namespace selector_internal;

		public function Selector(selectorString:String, context:SelectorContext = USE_DEFAULT_CONTEXT) {
			_selectorString = selectorString;

			_context = context;
			if (context == USE_DEFAULT_CONTEXT) {
				_context = DefaultSelectorContext
			}

			_context.addEventListener(DisplayListSelectorEvent.OBJECT_WAS_CHANGED, onObjectWasChanged, false, 0, true);

			parseAndStore(selectorString);
		}

		private function parseAndStore(selectorString:String):void {
			var parseResult:ParserResult = _context.parser.parse(selectorString);
			_specificity = parseResult.specificity;
			_matchers = parseResult.matchers;
		}

		public function get selectorString():String {
			return _selectorString;
		}

		private function onObjectWasChanged(event:DisplayListSelectorEvent):void {
			if (_matchedObjects && _matchedObjects.has(event.object)) {
				_matchedObjects = null;
			}
		}

		public function getMatchedObjects():Set {

			if (_matchedObjects == null) {
				_matchedObjects = _context.matcherTool.findMatchingObjects(_matchers);
			}

			return _matchedObjects;
		}

		public function isMatching(object:DisplayObject):Boolean {

			var isMatching:Boolean = _context.matcherTool.isObjectMatching(object as DisplayObject, _matchers);
			if(isMatching){trace("MATCHER rev matches " + object);}//TODO (arneschroppe 2/2/12) delete
			return isMatching;
		}

		public function get specificity():ISpecificity {
			return _specificity;
		}

		public function get context():SelectorContext {
			return _context;
		}


		
		//TODO (arneschroppe 20/1/12) add queries on selectors?
	}
}
