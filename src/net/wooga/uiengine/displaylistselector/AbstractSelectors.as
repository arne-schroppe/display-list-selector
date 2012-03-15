package net.wooga.uiengine.displaylistselector {
	import flash.utils.getQualifiedClassName;

	import net.wooga.uiengine.displaylistselector.matching.MatcherTool;
	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.parser.Parser;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.Active;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.FirstChild;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.Hover;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.IsEmpty;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.LastChild;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthChild;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthLastChild;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthLastOfType;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthOfType;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.Root;
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapterDelegate;
	import net.wooga.uiengine.displaylistselector.selectorstorage.SelectorStorage;
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;
	import net.wooga.uiengine.displaylistselector.tools.SpecificityComparator;
	import net.wooga.uiengine.displaylistselector.tools.Types;

	import org.as3commons.collections.LinkedSet;
	import org.as3commons.collections.Map;
	import org.as3commons.collections.SortedSet;
	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.collections.framework.ISet;

	public class AbstractSelectors implements ISelectorTool, ISelectorAdapterDelegate {

		private var _rootObject:Object;

		private var _parser:Parser;
		private var _matcher:MatcherTool;
		private var _knownSelectors:SelectorStorage = new SelectorStorage();

		private var _pseudoClassProvider:PseudoClassProvider;

		private var _objectToStyleAdapterMap:IMap = new Map();

		private var _objectTypeToStyleAdapterTypeMap:IMap = new Map();
		private var _defaultStyleAdapterType:Class;




		public function initializeWith(rootObject:Object, externalPropertySource:IExternalPropertySource = null):void {
			_rootObject = rootObject;

			var externalPropertySource:IExternalPropertySource = externalPropertySource;
			if (externalPropertySource == null) {
				externalPropertySource = new NullPropertySource();
			}

			_pseudoClassProvider = new PseudoClassProvider();
			addDefaultPseudoClasses();

			_parser = new Parser(externalPropertySource, _pseudoClassProvider);
			_matcher = new MatcherTool(_rootObject, _objectToStyleAdapterMap);
		}


		public function addSelector(selectorString:String):void {
			var parsed:Vector.<ParsedSelector> = _parser.parse(selectorString);

			for each(var selector:ParsedSelector in parsed) {
				_knownSelectors.add(selector);
			}
			
		}

		
		public function getSelectorsMatchingObject(object:Object):ISet {

			var adapter:ISelectorAdapter = _objectToStyleAdapterMap.itemFor(object);
			if(!adapter) {
				throw new ArgumentError("No style adapter registered for object " + object);
			}

			//TODO (arneschroppe 24/2/12) does using a sorted set here cause too much overhead?
			var matches:ISet = new SortedSet(new SpecificityComparator());


			var possibleMatches:IIterable = _knownSelectors.getPossibleMatchesFor(adapter);

			var keyIterator:IIterator = possibleMatches.iterator();
			while (keyIterator.hasNext()) {
				var selector:ParsedSelector = keyIterator.next();

				if (_matcher.isObjectMatching(adapter, selector)) {
					matches.add(selector);
				}
			}


			//TODO (arneschroppe 24/2/12) unique and sort result;

			var result:ISet = new LinkedSet();
			var resultIterator:IIterator = matches.iterator();
			while(resultIterator.hasNext()) {
				result.add((resultIterator.next() as ParsedSelector).originalSelector);
			}

			return result;
		}



		public function addPseudoClass(className:String, pseudoClass:IPseudoClass):void {
			if (_pseudoClassProvider.hasPseudoClass(className)) {
				throw new ArgumentError("Pseudo class " + className + " already exists");
			}

			_pseudoClassProvider.addPseudoClass(className, pseudoClass);
		}


		public function setStyleAdapterForType(adapterType:Class, objectType:Class):void {
			checkAdapterType(adapterType);
			_objectTypeToStyleAdapterTypeMap.add(getQualifiedClassName(objectType), adapterType);
		}


		public function setDefaultStyleAdapter(adapterType:Class):void {
			checkAdapterType(adapterType);
			_defaultStyleAdapterType = adapterType;
		}



		private function checkAdapterType(adapterType:Class):void {
			if (!Types.doesTypeImplementInterface(adapterType, ISelectorAdapter)) {
				throw new ArgumentError(getQualifiedClassName(adapterType) + " must implement " + getQualifiedClassName(ISelectorAdapter) + " to be registered as an adapter");
			}
		}



		public function createStyleAdapterFor(object:Object):void {
			if(_objectToStyleAdapterMap.hasKey(object)) {
				return;	
			}

			var SelectorClientClass:Class = getStyleAdapterClass(object);
			if(!SelectorClientClass) {
				//report("Warning! No selector client type registered for type " + getQualifiedClassName(object) + " and no default set!");
				return;
			}

			var selectorClient:ISelectorAdapter = new SelectorClientClass();
			_objectToStyleAdapterMap.add(object, selectorClient);
			selectorClient.register(object, this);

		}


		private function getStyleAdapterClass(object:Object):Class {
			var objectTypeName:String = getQualifiedClassName(object);
			var SelectorClientClass:Class = _objectTypeToStyleAdapterTypeMap.itemFor(objectTypeName);
			if (!SelectorClientClass) {
				SelectorClientClass = _defaultStyleAdapterType;
			}
			return SelectorClientClass;
		}


		public function removeStyleAdapterOf(object:Object):void {

			if(_objectToStyleAdapterMap.hasKey(object)) {
				var selectorClient:ISelectorAdapter = _objectToStyleAdapterMap.itemFor(object);
				selectorClient.unregister();
				_objectToStyleAdapterMap.removeKey(object);
			}
		}

		private function addDefaultPseudoClasses():void {
			addPseudoClass("root", new Root(_rootObject));
			addPseudoClass("first-child", new FirstChild());
			addPseudoClass("last-child", new LastChild());
			addPseudoClass("nth-child", new NthChild());
			addPseudoClass("nth-last-child", new NthLastChild());
			addPseudoClass("nth-of-type", new NthOfType());
			addPseudoClass("nth-last-of-type", new NthLastOfType());
			addPseudoClass("empty", new IsEmpty());
			addPseudoClass("hover", new Hover());
			addPseudoClass("active", new Active());
		}

		public function objectStateHasChanged(object:ISelectorAdapter):void {

		}
	}
}
