package net.wooga.selectors {

	import flash.utils.getQualifiedClassName;

	import net.wooga.selectors.matching.MatcherTool;
	import net.wooga.selectors.usagepatterns.Selector;
	import net.wooga.selectors.usagepatterns.SelectorGroup;
	import net.wooga.selectors.usagepatterns.SelectorPool;
	import net.wooga.selectors.usagepatterns.implementations.SelectorGroupImpl;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;
	import net.wooga.selectors.usagepatterns.implementations.SelectorPoolImpl;
	import net.wooga.selectors.parser.Parser;
	import net.wooga.selectors.pseudoclasses.Active;
	import net.wooga.selectors.pseudoclasses.FirstChild;
	import net.wooga.selectors.pseudoclasses.Hover;
	import net.wooga.selectors.pseudoclasses.PseudoClass;
	import net.wooga.selectors.pseudoclasses.IsEmpty;
	import net.wooga.selectors.pseudoclasses.LastChild;
	import net.wooga.selectors.pseudoclasses.NthChild;
	import net.wooga.selectors.pseudoclasses.NthLastChild;
	import net.wooga.selectors.pseudoclasses.NthLastOfType;
	import net.wooga.selectors.pseudoclasses.NthOfType;
	import net.wooga.selectors.pseudoclasses.Root;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.tools.Types;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMap;

	public class AbstractSelectorFactory implements SelectorFactory {

		use namespace selector_internal;

		private var _rootObject:Object;

		private var _parser:Parser;
		private var _matcher:MatcherTool;


		private var _pseudoClassProvider:PseudoClassProviderImpl;

		private var _objectToStyleAdapterMap:IMap = new Map();

		private var _objectTypeToStyleAdapterTypeMap:IMap = new Map();
		private var _defaultStyleAdapterType:Class;


		public function initializeWith(rootObject:Object, externalPropertySource:IExternalPropertySource = null):void {
			_rootObject = rootObject;

			var externalPropertySource:IExternalPropertySource = externalPropertySource;
			if (externalPropertySource == null) {
				externalPropertySource = new NullPropertySource();
			}

			_pseudoClassProvider = new PseudoClassProviderImpl();
			addDefaultPseudoClasses();

			_parser = new Parser(externalPropertySource, _pseudoClassProvider);
			_matcher = new MatcherTool(_rootObject, _objectToStyleAdapterMap);
		}


		public function createSelector(selectorString:String):SelectorGroup {
			var partialSelectors:Vector.<SelectorImpl> = _parser.parse(selectorString);

			var selectors:Vector.<Selector> = new <Selector>[];
			for each(var partialSelector:SelectorImpl in partialSelectors) {
				partialSelector.matcherTool = _matcher;
				partialSelector.objectToStyleAdapterMap = _objectToStyleAdapterMap;

				selectors.push(partialSelector);
			}
			
			return new SelectorGroupImpl(selectors);
		}


		public function createSelectorPool():SelectorPool {
			return new SelectorPoolImpl(_parser, _matcher, _objectToStyleAdapterMap);
		}


		public function addPseudoClass(className:String, pseudoClass:PseudoClass):void {
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
			if (!Types.doesTypeImplementInterface(adapterType, SelectorAdapter)) {
				throw new ArgumentError(getQualifiedClassName(adapterType) + " must implement " + getQualifiedClassName(SelectorAdapter) + " to be registered as an adapter");
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

			var selectorClient:SelectorAdapter = new SelectorClientClass();
			_objectToStyleAdapterMap.add(object, selectorClient);
			selectorClient.register(object);
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
				var selectorClient:SelectorAdapter = _objectToStyleAdapterMap.itemFor(object);
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


	}
}
