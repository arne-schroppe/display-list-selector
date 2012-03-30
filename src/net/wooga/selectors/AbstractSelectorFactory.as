package net.wooga.selectors {

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	import net.wooga.selectors.matching.MatcherTool;
	import net.wooga.selectors.parser.Parser;
	import net.wooga.selectors.pseudoclasses.FirstChild;
	import net.wooga.selectors.pseudoclasses.IsA;
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

	public class AbstractSelectorFactory implements SelectorFactory {

		use namespace selector_internal;

		private var _rootObject:Object;

		private var _parser:Parser;
		private var _matcher:MatcherTool;


		private var _pseudoClassProvider:PseudoClassProviderImpl;

		private var _objectToStyleAdapterMap:Dictionary = new Dictionary();

		private var _objectTypeToStyleAdapterTypeMap:Dictionary = new Dictionary();
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


		//TODO (arneschroppe 30/3/12) untested
		public function setStyleAdapterForType(adapterType:Class, objectType:Class):void {
			checkAdapterType(adapterType);
			_objectTypeToStyleAdapterTypeMap[getQualifiedClassName(objectType)] = adapterType;
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
			if(object in _objectToStyleAdapterMap) {
				return;	
			}

			var SelectorClientClass:Class = getStyleAdapterClass(object);
			if(!SelectorClientClass) {
				//report("Warning! No selector client type registered for type " + getQualifiedClassName(object) + " and no default set!");
				return;
			}

			var selectorClient:SelectorAdapter = new SelectorClientClass();
			_objectToStyleAdapterMap[object] = selectorClient;
			selectorClient.register(object);
		}


		private function getStyleAdapterClass(object:Object):Class {
			//TODO (arneschroppe 3/30/12) we could also just set the class name in the adapter
			var objectTypeName:String = getQualifiedClassName(object);
			var SelectorClientClass:Class = _objectTypeToStyleAdapterTypeMap[objectTypeName];
			if (!SelectorClientClass) {
				SelectorClientClass = _defaultStyleAdapterType;
			}

			return SelectorClientClass;
		}


		//TODO (arneschroppe 30/3/12) this method is untested
		public function removeStyleAdapterOf(object:Object):void {

			if(object in _objectToStyleAdapterMap) {
				var selectorClient:SelectorAdapter = _objectToStyleAdapterMap[object];
				selectorClient.unregister();
				delete _objectToStyleAdapterMap[object];
			}
		}

		private function addDefaultPseudoClasses():void {
			addPseudoClass(BuiltinPseudoClassName.is_a, new IsA());
			addPseudoClass(BuiltinPseudoClassName.root, new Root(_rootObject));
			addPseudoClass(BuiltinPseudoClassName.first_child, new FirstChild());
			addPseudoClass(BuiltinPseudoClassName.last_child, new LastChild());
			addPseudoClass(BuiltinPseudoClassName.nth_child, new NthChild());
			addPseudoClass(BuiltinPseudoClassName.nth_last_child, new NthLastChild());
			addPseudoClass(BuiltinPseudoClassName.nth_of_type, new NthOfType());
			addPseudoClass(BuiltinPseudoClassName.nth_last_of_type, new NthLastOfType());
			addPseudoClass(BuiltinPseudoClassName.empty, new IsEmpty());


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
				addPseudoClass(pseudoClassName, new SettablePseudoClass(pseudoClassName));
			}

		}

	}
}
