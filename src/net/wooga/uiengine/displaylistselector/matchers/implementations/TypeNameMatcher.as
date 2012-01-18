package net.wooga.uiengine.displaylistselector.matchers.implementations {

	import flash.display.DisplayObject;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	import net.wooga.uiengine.displaylistselector.matchers.*;
	import net.wooga.uiengine.displaylistselector.matchers.implementations.qualifiedtypename.QualifiedTypeNameParser;
	import net.wooga.uiengine.displaylistselector.tools.MultiMap;

	public class TypeNameMatcher implements IMatcher {

		private var _matchAny:Boolean = false;
		private var _onlyMatchImmediateClassType:Boolean;
		private var _typeMatcherRegEx:RegExp;
		private var _typeName:String;


		private static const _typeMatchCache:MultiMap = new MultiMap(2);
		private static const _typeNameParser:QualifiedTypeNameParser = new QualifiedTypeNameParser();

		public function TypeNameMatcher(typeName:String, onlyMatchImmediateClassType:Boolean = true) {

			_typeName = typeName;


			_onlyMatchImmediateClassType = onlyMatchImmediateClassType;
			if (typeName == "*") {
				_matchAny = true;
			}
			else {
				createTypeNameMatcherRegEx(typeName);
			}
		}

		private function createTypeNameMatcherRegEx(typeName:String):void {

			var normalizedName:String = typeName.replace("::", ".");
			_typeMatcherRegEx = _typeNameParser.createTypeMatcherRegEx(normalizedName);

		}


		public function isMatching(subject:DisplayObject):Boolean {
			if (_matchAny || matchesType(subject)) {
				return true;
			} else {
				return false;
			}
		}

		private function matchesType(subject:DisplayObject):Boolean {
			if(_onlyMatchImmediateClassType) {

				return isMatchingTypeName(getQualifiedClassName(subject));
			}

			return isAnySuperClassMatchingTypeName(subject);
		}


		private function isAnySuperClassMatchingTypeName(subject:DisplayObject):Boolean {

			var className:String = getQualifiedClassName(subject);
			var cacheEntry:MatchCacheEntry = _typeMatchCache.itemFor(_typeName, className);
			if(cacheEntry !== null) {
				return cacheEntry.isMatching;
			}

			var isMatching:Boolean = isMatchingTypeName(className) || hasSuperClassMatch(subject);
			_typeMatchCache.addOrReplace(_typeName, className, new MatchCacheEntry(isMatching));

			return isMatching;
		}


		public function hasSuperClassMatch(subject:DisplayObject):Boolean {
			var types:XMLList = describeType(subject).*.@type;

			for each(var type:XML in types) {
				if(isMatchingTypeName(type.toString())) {
					return true;
				}
			}

			return false;
		}


		private function isMatchingTypeName(typeName:String):Boolean {
			typeName = typeName.replace("::", ".");
			return _typeMatcherRegEx.test(typeName);
		}
	}
}


class MatchCacheEntry {

	public function MatchCacheEntry(isMatching:Boolean) {
		this.isMatching = isMatching;
	}

	public var isMatching:Boolean;
}
