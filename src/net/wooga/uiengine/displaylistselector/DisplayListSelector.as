package net.wooga.uiengine.displaylistselector {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import net.wooga.uiengine.displaylistselector.matchers.Matchers;
	import net.wooga.uiengine.displaylistselector.parser.Parser;
	import net.wooga.uiengine.displaylistselector.parser.ParserResult;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.FirstChild;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.IsEmpty;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.LastChild;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthChild;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthLastChild;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthLastOfType;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthOfType;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.Root;
	import net.wooga.uiengine.displaylistselector.selectorcomparator.SelectorComparator;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.Set;
	import org.as3commons.collections.SortedSet;
	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.ISet;

	public class DisplayListSelector extends EventDispatcher {


		private var _rootObject:DisplayObjectContainer;

		private var _parser:Parser;
		private var _matchers:Matchers;


		private var _externalPropertySource:IExternalPropertySource;
		private var _pseudoClassProvider:PseudoClassProvider;

		private var _selectorToSpecificityMap:Map = new Map();

		private var _objectsBeingAdded:Set;


		public function DisplayListSelector(rootObject:DisplayObjectContainer, externalPropertySource:IExternalPropertySource = null, idAttribute:String = "name", classAttribute:String = "group") {
			_rootObject = rootObject;

			_rootObject.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, true);
			_rootObject.addEventListener(Event.ADDED, onAdded);
			_rootObject.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, true);

			_externalPropertySource = externalPropertySource;
			if (_externalPropertySource == null) {
				_externalPropertySource = new NullPropertySource();
			}

			_pseudoClassProvider = new PseudoClassProvider();
			addDefaultPseudoClasses();

			_parser = new Parser(_externalPropertySource, _pseudoClassProvider, idAttribute, classAttribute);
			_matchers = new Matchers(_rootObject);
		}


		public function objectHasChanged(object:DisplayObject):void {
			_matchers.objectHasChanged(object);
		}

		private function onRemoved(event:Event):void {
			var object:DisplayObject = event.target as DisplayObject;

			if(_objectsBeingAdded && _objectsBeingAdded.has(object)) {
				_objectsBeingAdded.remove(object);
			}

			//objectHasChanged(object);
			//TODO (arneschroppe 11/1/12) use objectWasRemoved here
		}


		private var _isAddedDirectly:Set = new Set();
		private function onAdded(event:Event):void {
			_isAddedDirectly.add(event.target);

		}

		private function onAddedToStage(event:Event):void {

			if(_objectsBeingAdded == null) {
				_objectsBeingAdded = new Set();
				_rootObject.addEventListener(Event.ENTER_FRAME, resetAddedObjects);
			}

			var object:DisplayObject = event.target as DisplayObject;
			addObjectAndChildren(object);
		}

		private function resetAddedObjects(event:Event):void {
			_rootObject.removeEventListener(Event.ENTER_FRAME, resetAddedObjects);
			_objectsBeingAdded = null;
		}

		private function addObjectAndChildren(object:DisplayObject):void {
			if(!_objectsBeingAdded.has(object)) {
				_objectsBeingAdded.add(object);
				dispatchEvent(new DisplayListSelectorEvent(DisplayListSelectorEvent.OBJECT_WAS_ADDED, object));
			}


			if(object is DisplayObjectContainer) {
				var container:DisplayObjectContainer = object as DisplayObjectContainer;
				for(var i:int = 0; i < container.numChildren; ++i) {
					addObjectAndChildren(container.getChildAt(i));
				}
			}
		}




		public function getSpecificityForSelector(selector:String):Number {
			if(!_selectorToSpecificityMap.hasKey(selector)) {
				throw new Error("Selector " + selector + "has not been parsed yet");
			}
			return _selectorToSpecificityMap.itemFor(selector);
		}


		//TODO (arneschroppe 12/1/12) change return type to Array
		public function getObjectsForSelector(selector:String):Set {
			
			parseIfNeeded(selector);
			
			var matchedObjects:Set = _matchers.findMatchesFor(selector);
			return matchedObjects;
		}

		private function parseIfNeeded(selector:String):void {
			if (!_matchers.hasMatchersForSelector(selector)) {
				parseAndCache(selector);
			}
		}


		private function parseAndCache(selector:String):void {
			var parserResult:ParserResult = _parser.parse(selector);
			_selectorToSpecificityMap.add(selector, parserResult.specificity);
			_matchers.setMatchersForSelector(selector, parserResult.matchers);
		}


		//TODO (arneschroppe 11/1/12) we need a well-defined way to determine when a pseudo-class needs to be rematched. many of these only work with a very static display tree
		private function addDefaultPseudoClasses():void {
			addPseudoClass("root", new Root(_rootObject));
			addPseudoClass("first-child", new FirstChild());
			addPseudoClass("last-child", new LastChild());
			addPseudoClass("nth-child", new NthChild());
			addPseudoClass("nth-last-child", new NthLastChild());
			addPseudoClass("nth-of-type", new NthOfType());
			addPseudoClass("nth-last-of-type", new NthLastOfType());
			addPseudoClass("empty", new IsEmpty());
		}


		public function addPseudoClass(className:String, pseudoClass:IPseudoClass):void {
			if (_pseudoClassProvider.hasPseudoClass(className)) {
				throw new ArgumentError("Pseudo class " + className + " already exists");
			}

			_pseudoClassProvider.addPseudoClass(className, pseudoClass);
		}

		public function getSelectorsMatchingObject(object:Object, selectors:IIterable):ISet {
			//TODO (arneschroppe 9/1/12) parse selector if it's not known yet
			return _matchers.getSelectorsMatchingObject(object as DisplayObject, selectors, new SelectorComparator(this));
		}


		//TODO (arneschroppe 12/1/12) we should not have this method, it clutters up our interface. maybe have the option to parse multiple selectors, then sort result by selectors
		public function sortSelectors(selectors:IIterable):IIterable {
			var sortedSelectors:SortedSet = new SortedSet(new SelectorComparator(this));

			var iterator:IIterator = selectors.iterator();
			while(iterator.hasNext()) {
				var currentSelector:String = iterator.next();
				parseIfNeeded(currentSelector);
				sortedSelectors.add(currentSelector);
			}

			return sortedSelectors;
		}


	}
}
