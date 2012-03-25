package net.wooga.selectors {

	import flash.utils.getQualifiedClassName;

	import net.wooga.selectors.matching.MatcherTool;
	import net.wooga.selectors.parser.Parser;
	import net.wooga.selectors.pseudoclasses.FirstChild;
	import net.wooga.selectors.pseudoclasses.IsEmpty;
	import net.wooga.selectors.pseudoclasses.LastChild;
	import net.wooga.selectors.pseudoclasses.NthChild;
	import net.wooga.selectors.pseudoclasses.NthLastChild;
	import net.wooga.selectors.pseudoclasses.NthLastOfType;
	import net.wooga.selectors.pseudoclasses.NthOfType;
	import net.wooga.selectors.pseudoclasses.PseudoClass;
	import net.wooga.selectors.pseudoclasses.Root;
	import net.wooga.selectors.pseudoclasses.SettablePseudoClass;
	import net.wooga.selectors.pseudoclasses.names.BuiltinPseudoClassName;
	import net.wooga.selectors.pseudoclasses.names.PseudoClassName;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.tools.Types;
	import net.wooga.selectors.usagepatterns.Selector;
	import net.wooga.selectors.usagepatterns.SelectorGroup;
	import net.wooga.selectors.usagepatterns.SelectorPool;
	import net.wooga.selectors.usagepatterns.implementations.SelectorGroupImpl;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;
	import net.wooga.selectors.usagepatterns.implementations.SelectorPoolImpl;

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
			addPseudoClass(BuiltinPseudoClassName.root, new Root(_rootObject));
			addPseudoClass(BuiltinPseudoClassName.first_child, new FirstChild());
			addPseudoClass(BuiltinPseudoClassName.last_child, new LastChild());
			addPseudoClass(BuiltinPseudoClassName.nth_child, new NthChild());
			addPseudoClass(BuiltinPseudoClassName.nth_last_child, new NthLastChild());
			addPseudoClass(BuiltinPseudoClassName.nth_of_type, new NthOfType());
			addPseudoClass(BuiltinPseudoClassName.nth_last_of_type, new NthLastOfType());
			addPseudoClass(BuiltinPseudoClassName.empty, new IsEmpty());

			addPseudoClass(PseudoClassName.hover, new SettablePseudoClass(PseudoClassName.hover));
			addPseudoClass(PseudoClassName.active, new SettablePseudoClass(PseudoClassName.active));
			addPseudoClass(PseudoClassName.focus, new SettablePseudoClass(PseudoClassName.focus));
			addPseudoClass(PseudoClassName.link, new SettablePseudoClass(PseudoClassName.link));
			addPseudoClass(PseudoClassName.visited, new SettablePseudoClass(PseudoClassName.visited));
			addPseudoClass(PseudoClassName.target, new SettablePseudoClass(PseudoClassName.target));
			addPseudoClass(PseudoClassName.enabled, new SettablePseudoClass(PseudoClassName.enabled));
			addPseudoClass(PseudoClassName.disabled, new SettablePseudoClass(PseudoClassName.disabled));
			addPseudoClass(PseudoClassName.checked, new SettablePseudoClass(PseudoClassName.checked));
			addPseudoClass(PseudoClassName.indeterminate, new SettablePseudoClass(PseudoClassName.indeterminate));
		}


	}
}
