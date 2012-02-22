package net.wooga.uiengine.displaylistselector {
	import flash.utils.getQualifiedClassName;

	import net.wooga.uiengine.displaylistselector.matching.old.MatcherTool;
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
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;
	import net.wooga.uiengine.displaylistselector.tools.SpecificityComparator;
	import net.wooga.uiengine.displaylistselector.tools.Types;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.SortedSet;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.collections.framework.ISet;

	public class AbstractSelectors implements ISelectorTool {

		private var _rootObject:Object;

		private var _parser:Parser;
		private var _pseudoClassProvider:PseudoClassProvider;

		private var _matcher:MatcherTool;

		private var _knownSelectors:Map = new Map();

		private var _objectToStyleAdapterMap:IMap = new Map();
		private var _objectTypeToStyleAdapterTypeMap:IMap = new Map();
		private var _defaultStyleAdapterType:Class;



		//TODO (arneschroppe 21/2/12) id and class attributes are of course also reflected through adapters
		public function initializeWith(rootObject:Object, externalPropertySource:IExternalPropertySource = null, idAttribute:String = "name", classAttribute:String = "group"):void {
			_rootObject = rootObject;
			//TODO (arneschroppe 21/2/12) we don't need to know the root object, we only need to check for the root property on the adapter! (but will everyone implement this properly?)

			var externalPropertySource:IExternalPropertySource = externalPropertySource;
			if (externalPropertySource == null) {
				externalPropertySource = new NullPropertySource();
			}

			_pseudoClassProvider = new PseudoClassProvider();
			addDefaultPseudoClasses();

			_parser = new Parser(externalPropertySource, _pseudoClassProvider, idAttribute, classAttribute);
			_matcher = new MatcherTool(_rootObject);
		}


		public function addSelector(selectorString:String):void {
			var parsed:ParserResult = _parser.parse(selectorString);
			_knownSelectors.add(selectorString, parsed);
		}

		//TODO (arneschroppe 14/2/12) use selector tree here, for optimization
		public function getSelectorsMatchingObject(object:Object):ISet {

			var adapter:IStyleAdapter = _objectToStyleAdapterMap.itemFor(object);
			if(!adapter) {
				throw new ArgumentError("No style adapter registered for object " + object);
			}

			var result:ISet = new SortedSet(new SpecificityComparator(_knownSelectors));

			var keyIterator:IIterator = _knownSelectors.keyIterator();
			while (keyIterator.hasNext()) {
				var selector:String = keyIterator.next();
				var parsed:ParserResult = _knownSelectors.itemFor(selector);

				if (_matcher.isObjectMatching(adapter, parsed.matchers)) {
					result.add(selector);
				}
			}

			return result;
		}




		public function addPseudoClass(className:String, pseudoClass:IPseudoClass):void {
			if (_pseudoClassProvider.hasPseudoClass(className)) {
				throw new ArgumentError("Pseudo class " + className + " already exists");
			}

			_pseudoClassProvider.addPseudoClass(className, pseudoClass);
		}


		public function objectWasChanged(object:Object):void {
			_matcher.invalidateObject(object);
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
			if (!Types.doesTypeImplementInterface(adapterType, IStyleAdapter)) {
				throw new ArgumentError(getQualifiedClassName(adapterType) + " must implement " + getQualifiedClassName(IStyleAdapter) + " to be registered as an adapter");
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

			var selectorClient:IStyleAdapter = new SelectorClientClass();
			_objectToStyleAdapterMap.add(object, selectorClient);
			selectorClient.register(object);

			var parentElement:Object = selectorClient.getParentElement();
			var parentAdapter:IStyleAdapter = _objectToStyleAdapterMap.itemFor(parentElement);
			
			if(!parentAdapter) {
				return;
			}

			selectorClient.setParent(parentAdapter);
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
				var selectorClient:IStyleAdapter = _objectToStyleAdapterMap.itemFor(object);
				selectorClient.unregister(object);
				_objectToStyleAdapterMap.removeKey(object);
			}
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


	}
}
