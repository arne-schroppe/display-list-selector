package net.wooga.uiengine.displaylistselector.matching.matchers.implementations {

	import flash.display.DisplayObject;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	import net.wooga.uiengine.displaylistselector.matching.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.matching.matchers.implementations.qualifiedtypename.QualifiedTypeNameParser;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMap;

	public class TypeNameMatcher implements IMatcher {

		private var _matchAny:Boolean = false;
		private var _simpleMatch:Boolean = false;
		private var _onlyMatchImmediateClassType:Boolean = true;

		private var _typeMatcherRegEx:RegExp;
		private var _typeName:String;


		private static const _typeMatchCache:IMap = new Map();
		private static const _directMatchTypeMatchCache:IMap = new Map();
		private static const _typeNameParser:QualifiedTypeNameParser = new QualifiedTypeNameParser();

		public function TypeNameMatcher(typeName:String, onlyMatchImmediateClassType:Boolean = true) {
			_onlyMatchImmediateClassType = onlyMatchImmediateClassType;

			_typeName = typeName;
			if (_typeName == "*") {
				_matchAny = true;
			}
			else if(/^(\w|\$)+$/i.test(_typeName)) {
				_simpleMatch = true;
			}
			else {
				createTypeNameMatcherRegEx(typeName);
			}
		}

		private function createTypeNameMatcherRegEx(typeName:String):void {
			var normalizedName:String = typeName.replace("::", ".");
			var regExString:String = _typeNameParser.createTypeMatcherRegEx(normalizedName);
			_typeMatcherRegEx = new RegExp(regExString, "i")
		}


		public function isMatching(subject:DisplayObject):Boolean {
			return _matchAny || matchesType(subject);

		}

		private function matchesType(subject:DisplayObject):Boolean {
			if(_onlyMatchImmediateClassType) {
				var className:String = getQualifiedClassName(subject);
				return isMatchingType(className);

			}

			return isAnySuperClassMatchingTypeName(subject);
		}


		private function isAnySuperClassMatchingTypeName(subject:DisplayObject):Boolean {

			var className:String = getQualifiedClassName(subject);
			var key:String = createDictKeyFor(className);
			var cacheEntry:MatchCacheEntry = _typeMatchCache.itemFor(key);
			if(cacheEntry !== null) {
				return cacheEntry.isMatching;
			}

			var isMatching:Boolean = isMatchingType(className) || hasSuperClassMatch(subject);
			_typeMatchCache.add(key, new MatchCacheEntry(isMatching));

			return isMatching;
		}


		public function hasSuperClassMatch(subject:DisplayObject):Boolean {
			var types:XMLList = describeType(subject).*.@type;

			for each(var type:XML in types) {
				if(isMatchingType(type.toString())) {
					return true;
				}
			}

			return false;
		}

		private function isMatchingType(className:String):Boolean {


			if(_simpleMatch) {
				return className.split("::").pop() == _typeName;
			}

			var key:String = createDictKeyFor(className);
			var cacheEntry:MatchCacheEntry = _directMatchTypeMatchCache.itemFor(key);
			if(cacheEntry !== null) {
				return cacheEntry.isMatching;
			}

			var isMatching:Boolean = isTypeRegExMatching(className);
			_directMatchTypeMatchCache.add(key, new MatchCacheEntry(isMatching));
			return isMatching;
		}


		private function isTypeRegExMatching(typeName:String):Boolean {
			typeName = typeName.replace("::", ".");
			return _typeMatcherRegEx.test(typeName);
		}



		private function createDictKeyFor(className:String):String {
			return _typeName + "&" + className;
		}

	}
}


class MatchCacheEntry {

	public function MatchCacheEntry(isMatching:Boolean) {
		this.isMatching = isMatching;
	}

	public var isMatching:Boolean;
}
