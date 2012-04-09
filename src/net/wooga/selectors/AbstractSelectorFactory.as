package net.wooga.selectors {

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	import net.wooga.selectors.adaptermap.SelectorAdapterMap;

	import net.wooga.selectors.matching.MatcherTool;
	import net.wooga.selectors.namespace.selector_internal;
	import net.wooga.selectors.parser.Parser;
	import net.wooga.selectors.pseudoclasses.FirstChild;
	import net.wooga.selectors.pseudoclasses.FirstOfType;
	import net.wooga.selectors.pseudoclasses.IsA;
	import net.wooga.selectors.pseudoclasses.IsEmpty;
	import net.wooga.selectors.pseudoclasses.LastChild;
	import net.wooga.selectors.pseudoclasses.LastOfType;
	import net.wooga.selectors.pseudoclasses.NthChild;
	import net.wooga.selectors.pseudoclasses.NthLastChild;
	import net.wooga.selectors.pseudoclasses.NthLastOfType;
	import net.wooga.selectors.pseudoclasses.NthOfType;
	import net.wooga.selectors.pseudoclasses.OnlyChild;
	import net.wooga.selectors.pseudoclasses.OnlyOfType;
	import net.wooga.selectors.pseudoclasses.Root;
	import net.wooga.selectors.pseudoclasses.SettablePseudoClass;
	import net.wooga.selectors.pseudoclasses.names.BuiltinPseudoClassName;
	import net.wooga.selectors.pseudoclasses.names.PseudoClassName;
	import net.wooga.selectors.pseudoclasses.provider.PseudoClassProviderImpl;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;
	import net.wooga.selectors.tools.Types;
	import net.wooga.selectors.usagepatterns.Selector;
	import net.wooga.selectors.usagepatterns.SelectorGroup;
	import net.wooga.selectors.usagepatterns.SelectorPool;
	import net.wooga.selectors.usagepatterns.implementations.SelectorGroupImpl;
	import net.wooga.selectors.usagepatterns.implementations.SelectorImpl;
	import net.wooga.selectors.usagepatterns.implementations.SelectorPoolImpl;

	public class AbstractSelectorFactory implements SelectorFactory {

		use namespace selector_internal;

		private var _rootObject:Object;

		private var _parser:Parser;
		private var _matcher:MatcherTool;

		private var _selectorAdapterMap:SelectorAdapterMap;

		private var _pseudoClassProvider:PseudoClassProviderImpl;



		private var _objectTypeToSelectorAdapterTypeMap:Dictionary = new Dictionary();
		private var _defaultSelectorAdapterType:Class;

		private var _isInitialized:Boolean;


		public function initializeWith(rootObject:Object, externalPropertySource:ExternalPropertySource = null, pseudoElementSource:PseudoElementSource = null):void {

			if(_isInitialized) {
				throw new Error("Factory is already initialized");
			}
			
			_rootObject = rootObject;

			var externalPropertySource:ExternalPropertySource = externalPropertySource;
			if (externalPropertySource == null) {
				externalPropertySource = new NullPropertySource();
			}

			_pseudoClassProvider = new PseudoClassProviderImpl();
			addDefaultPseudoClasses();

			_selectorAdapterMap = new SelectorAdapterMap();
			_parser = new Parser(externalPropertySource, pseudoElementSource, _pseudoClassProvider);
			_matcher = new MatcherTool(_rootObject, _selectorAdapterMap);

			_isInitialized = true;
		}


		public function createSelector(selectorString:String):SelectorGroup {
			var partialSelectors:Vector.<SelectorImpl> = _parser.parse(selectorString);

			var selectors:Vector.<Selector> = new <Selector>[];
			for each(var partialSelector:SelectorImpl in partialSelectors) {
				partialSelector.matcherTool = _matcher;
				partialSelector.adapterMap = _selectorAdapterMap;

				selectors.push(partialSelector);
			}
			
			return new SelectorGroupImpl(selectors);
		}


		public function createSelectorPool():SelectorPool {
			return new SelectorPoolImpl(_parser, _matcher, _selectorAdapterMap);
		}


		public function addPseudoClass(className:String, pseudoClassType:Class, constructorArguments:Array=null):void {
			if (_pseudoClassProvider.hasPseudoClass(className)) {
				throw new ArgumentError("Pseudo class " + className + " already exists");
			}

			_pseudoClassProvider.addPseudoClass(className, pseudoClassType, constructorArguments);
		}


		//TODO (arneschroppe 30/3/12) untested
		public function setSelectorAdapterForType(adapterType:Class, objectType:Class):void {
			checkAdapterType(adapterType);
			_objectTypeToSelectorAdapterTypeMap[getQualifiedClassName(objectType)] = adapterType;
		}


		public function setDefaultSelectorAdapter(adapterType:Class):void {
			checkAdapterType(adapterType);
			_defaultSelectorAdapterType = adapterType;
		}



		private function checkAdapterType(adapterType:Class):void {
			if (!Types.doesTypeImplementInterface(adapterType, SelectorAdapter)) {
				throw new ArgumentError(getQualifiedClassName(adapterType) + " must implement " + getQualifiedClassName(SelectorAdapter) + " to be registered as an adapter");
			}
		}


		//TODO (arneschroppe 08/04/2012) test overrideDefaultSelectorAdapter !!
		public function createSelectorAdapterFor(object:Object, overrideDefaultSelectorAdapter:Class = null):void {
			if(_selectorAdapterMap.hasAdapterForObject(object)) {
				return;	
			}

			var SelectorClientClass:Class;

			if(overrideDefaultSelectorAdapter) {
				checkAdapterType(overrideDefaultSelectorAdapter);
				SelectorClientClass = overrideDefaultSelectorAdapter;
			}
			else {
				SelectorClientClass = getSelectorAdapterClass(object);
			}

			if(!SelectorClientClass) {
				//report("Warning! No selector client type registered for type " + getQualifiedClassName(object) + " and no default set!");
				return;
			}

			var selectorClient:SelectorAdapter = new SelectorClientClass();
			_selectorAdapterMap.setAdapterForObject(object, selectorClient);
			selectorClient.register(object);
		}


		private function getSelectorAdapterClass(object:Object):Class {
			//TODO (arneschroppe 3/30/12) we could also just set the class name in the adapter
			var objectTypeName:String = getQualifiedClassName(object);
			var SelectorClientClass:Class = _objectTypeToSelectorAdapterTypeMap[objectTypeName];
			if (!SelectorClientClass) {
				SelectorClientClass = _defaultSelectorAdapterType;
			}

			return SelectorClientClass;
		}


		//TODO (arneschroppe 30/3/12) this method is untested
		public function removeSelectorAdapterOf(object:Object):void {
			_selectorAdapterMap.removeAdapterForObject(object);
		}

		private function addDefaultPseudoClasses():void {
			addPseudoClass(BuiltinPseudoClassName.is_a, IsA);
			addPseudoClass(BuiltinPseudoClassName.root, Root, [_rootObject]);
			addPseudoClass(BuiltinPseudoClassName.first_child, FirstChild);
			addPseudoClass(BuiltinPseudoClassName.last_child, LastChild);
			addPseudoClass(BuiltinPseudoClassName.nth_child, NthChild);
			addPseudoClass(BuiltinPseudoClassName.nth_last_child, NthLastChild);
			addPseudoClass(BuiltinPseudoClassName.nth_of_type, NthOfType);
			addPseudoClass(BuiltinPseudoClassName.nth_last_of_type, NthLastOfType);
			addPseudoClass(BuiltinPseudoClassName.first_of_type, FirstOfType);
			addPseudoClass(BuiltinPseudoClassName.last_of_type, LastOfType);
			addPseudoClass(BuiltinPseudoClassName.empty, IsEmpty);
			addPseudoClass(BuiltinPseudoClassName.only_child, OnlyChild);
			addPseudoClass(BuiltinPseudoClassName.only_of_type, OnlyOfType);


			for each(var pseudoClassName:String in [
					PseudoClassName.hover,
					PseudoClassName.active,
					PseudoClassName.focus,
					PseudoClassName.link,
					PseudoClassName.visited,
					PseudoClassName.target,
					PseudoClassName.enabled,
					PseudoClassName.disabled,
					PseudoClassName.checked,
					PseudoClassName.indeterminate]) {
				addPseudoClass(pseudoClassName, SettablePseudoClass, [pseudoClassName]);
			}

		}

	}
}
