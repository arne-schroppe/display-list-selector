package net.wooga.uiengine.displaylistselector {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import net.wooga.uiengine.displaylistselector.matchers.MatcherTool;
	import net.wooga.uiengine.displaylistselector.parser.Parser;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.FirstChild;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.IsEmpty;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.LastChild;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthChild;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthLastChild;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthLastOfType;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.NthOfType;
	import net.wooga.uiengine.displaylistselector.pseudoclasses.Root;
	import net.wooga.uiengine.displaylistselector.IExternalPropertySource;

	import org.as3commons.collections.Set;

	public class SelectorContext extends EventDispatcher {

		private var _rootObject:DisplayObjectContainer;
		private var _objectsBeingAdded:Set;

		private var _parser:Parser;
		private var _pseudoClassProvider:PseudoClassProvider;

		private var _matcher:MatcherTool;

		public function initializeWith(rootObject:DisplayObjectContainer, externalPropertySource:IExternalPropertySource = null, idAttribute:String = "name", classAttribute:String = "group"):void {
			_rootObject = rootObject;

			_rootObject.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, true);
			_rootObject.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, true);

			var externalPropertySource:IExternalPropertySource = externalPropertySource;
			if (externalPropertySource == null) {
				externalPropertySource = new NullPropertySource();
			}

			_pseudoClassProvider = new PseudoClassProvider();
			addDefaultPseudoClasses();

			_parser = new Parser(externalPropertySource, _pseudoClassProvider, idAttribute, classAttribute);

			_matcher = new MatcherTool(_rootObject);
		}

		selector_internal function get parser():Parser {
			return _parser;
		}


		selector_internal function get matcherTool():MatcherTool {
			return _matcher;
		}


		private function onAddedToStage(event:Event):void {

			if(_objectsBeingAdded == null) {
				_objectsBeingAdded = new Set();
				_rootObject.addEventListener(Event.ENTER_FRAME, resetAddedObjects);
			}

			var object:DisplayObject = event.target as DisplayObject;
			addObjectAndChildren(object);
		}



		private function addObjectAndChildren(object:DisplayObject):void {
			if(!_objectsBeingAdded.has(object)) {
				_objectsBeingAdded.add(object);
				_matcher.invalidateObject(object);
				dispatchEvent(new DisplayListSelectorEvent(DisplayListSelectorEvent.OBJECT_WAS_ADDED, object));
			}


			if(object is DisplayObjectContainer) {
				var container:DisplayObjectContainer = object as DisplayObjectContainer;
				for(var i:int = 0; i < container.numChildren; ++i) {
					addObjectAndChildren(container.getChildAt(i));
				}
			}
		}


		private function resetAddedObjects(event:Event):void {
			_rootObject.removeEventListener(Event.ENTER_FRAME, resetAddedObjects);
			_objectsBeingAdded = null;
		}


		private function onRemoved(event:Event):void {
			var object:DisplayObject = event.target as DisplayObject;

			if(_objectsBeingAdded && _objectsBeingAdded.has(object)) {
				_objectsBeingAdded.remove(object);
			}

			_matcher.invalidateObject(object);
			//objectHasChanged(object);
			//TODO (arneschroppe 11/1/12) use objectWasRemoved here
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

		public function objectWasChanged(object:DisplayObject):void {
			_matcher.invalidateObject(object);
			dispatchEvent(new DisplayListSelectorEvent(DisplayListSelectorEvent.OBJECT_WAS_CHANGED, object));

		}


	}
}
