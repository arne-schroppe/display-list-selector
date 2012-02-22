package net.wooga.uiengine.displaylistselector {
	import flash.display.DisplayObject;

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
	import net.wooga.uiengine.displaylistselector.tools.SpecificityComparator;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.SortedSet;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.ISet;

	public class AbstractSelectors implements ISelectorTool {

		private var _rootObject:Object;

		private var _parser:Parser;
		private var _pseudoClassProvider:PseudoClassProvider;

		private var _matcher:MatcherTool;

		private var _knownSelectors:Map = new Map();


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

			var result:ISet = new SortedSet(new SpecificityComparator(_knownSelectors));

			var keyIterator:IIterator = _knownSelectors.keyIterator();
			while (keyIterator.hasNext()) {
				var selector:String = keyIterator.next();
				var parsed:ParserResult = _knownSelectors.itemFor(selector);

				if (_matcher.isObjectMatching(object as DisplayObject, parsed.matchers)) {
					result.add(selector);
				}
			}

			return result;
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


		public function objectWasChanged(object:Object):void {
			_matcher.invalidateObject(object);
		}

	}
}
