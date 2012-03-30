package net.wooga.selectors.matching.matchers.implementations {

	import flash.utils.Dictionary;

	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	//TODO (arneschroppe 19/3/12) operations in this class take too much time, especially isMatching and calls to addFromCollection
	public class TypeNameMatcher implements IMatcher {

		private var _matchAny:Boolean = false;
		private var _onlyMatchesImmediateType:Boolean = true;
		private var _typeName:String;
		private static const _typeMatchCache:Dictionary = new Dictionary();

		private var _classNameOnly:Boolean;

		//TODO (arneschroppe 23/2/12) always use the :: notation internally
		public function TypeNameMatcher(typeName:String, onlyMatchImmediateClassType:Boolean = true) {
			_onlyMatchesImmediateType = onlyMatchImmediateClassType;

			if (typeName == "*") {
				_matchAny = true;
				return;
			}

			if(/^(\w|\$)+$/i.test(typeName)) {
				_classNameOnly = true;
			}
			else if(/^\s*((\w|\$)+\.)*(\w|\$)+\s*$/i.test(typeName)) {
				typeName = convertToDoubleColonForm(typeName);
			}
			else if(!/^\s*(((\w|\$)+\.)*((\w|\$)+::))?(\w|\$)+\s*$/i.test(typeName)) {
				throw new ArgumentError("Invalid type name: " + typeName);
			}

			_typeName = typeName;
		}

		private function convertToDoubleColonForm(typeName:String):String {

			var index:int = typeName.lastIndexOf(".");
			return typeName.substring(0, index) + "::" + typeName.substring(index + 1, typeName.length);

		}


		public function isMatching(subject:SelectorAdapter):Boolean {
			return _matchAny || matchesType(subject);

		}


		private function matchesType(adapter:SelectorAdapter):Boolean {


			if(_onlyMatchesImmediateType) {
				return isMatchingType(adapter.getFullyQualifiedElementClassName());
			}

			return isAnySuperClassMatchingTypeName(adapter);
		}


		private function isAnySuperClassMatchingTypeName(adapter:SelectorAdapter):Boolean {

			var className:String = adapter.getElementClassName();
			var key:String = createDictKeyFor(className);
			var cacheEntry:MatchCacheEntry = _typeMatchCache[key];
			if(cacheEntry !== null) {
				return cacheEntry.isMatching;
			}

			var isMatching:Boolean = isMatchingType(className) || hasSuperClassMatch(adapter);
			_typeMatchCache[key] = new MatchCacheEntry(isMatching);

			return isMatching;
		}


		private function hasSuperClassMatch(adapter:SelectorAdapter):Boolean {

			var implementedTypes:Vector.<String> = adapter.getQualifiedInterfacesAndClasses();

			for each(var type:String in implementedTypes) {
				if(isMatchingType(type.toString())) {
					return true;
				}
			}

			return false;
		}


		//TODO (arneschroppe 3/30/12) optimize this, we don't need to split here
		private function isMatchingType(className:String):Boolean {

			if(_classNameOnly) {
				return className.split("::").pop() == _typeName;
			}
			else {
				return className == _typeName;
			}
		}


		private function createDictKeyFor(className:String):String {
			return _typeName + "&" + className;
		}

		public function get typeName():String {
			return _typeName;
		}

		public function get onlyMatchesImmediateType():Boolean {
			return _onlyMatchesImmediateType;
		}
	}
}


class MatchCacheEntry {

	public function MatchCacheEntry(isMatching:Boolean) {
		this.isMatching = isMatching;
	}

	public var isMatching:Boolean;
}
