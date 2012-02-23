package net.wooga.uiengine.displaylistselector.matching.old.matchers.implementations {

	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import net.wooga.uiengine.displaylistselector.matching.old.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.implementations.qualifiedtypename.QualifiedTypeNameParser;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMap;

	public class TypeNameMatcher implements IMatcher {

		private var _matchAny:Boolean = false;
		//private var _simpleMatch:Boolean = false;

		private var _onlyMatchImmediateClassType:Boolean = true;

		//private var _typeMatcherRegEx:RegExp;
		private var _typeName:String;


		private static const _typeMatchCache:IMap = new Map();
		private static const _directMatchTypeMatchCache:IMap = new Map();
		private static const _typeNameParser:QualifiedTypeNameParser = new QualifiedTypeNameParser();

		//TODO (arneschroppe 23/2/12) always use the :: notation internally
		public function TypeNameMatcher(typeName:String, onlyMatchImmediateClassType:Boolean = true) {
			_onlyMatchImmediateClassType = onlyMatchImmediateClassType;

			if (typeName == "*") {
				_matchAny = true;
				return;
			}

			if(!/^\s*((\w|\$)+\.)*(\w|\$)+\s*$/i.test(typeName)) {
				throw new ArgumentError("Invalid type name: " + typeName);
			}

			_typeName = typeName.replace("::", ".");

			//else if(/^(\w|\$)+$/i.test(_typeName)) {
			//	_simpleMatch = true;
			//}
			//else {
			//	createTypeNameMatcherRegEx(typeName);
			//}
		}

		//
		//private function createTypeNameMatcherRegEx(typeName:String):void {
		//	var normalizedName:String = typeName.replace("::", ".");
		//	var regExString:String = _typeNameParser.createTypeMatcherRegEx(normalizedName);
		//	_typeMatcherRegEx = new RegExp(regExString, "i")
		//}


		public function isMatching(subject:IStyleAdapter):Boolean {
			return _matchAny || matchesType(subject);

		}


		private function matchesType(adapter:IStyleAdapter):Boolean {

			try {
				getDefinitionByName(_typeName)
			}
			catch(e:Error) {
				trace("Warning: " + _typeName + " doesn't seem to exist");
			}
			
			//TODO (arneschroppe 22/2/12) maybe we can find a way to avoid using the adapted element directly
			var subject:Object = adapter.getAdaptedElement();

			if(_onlyMatchImmediateClassType) {
				var className:String = getQualifiedClassName(subject);
				return isMatchingType(className);
			}

			return isAnySuperClassMatchingTypeName(subject);
		}


		private function isAnySuperClassMatchingTypeName(subject:Object):Boolean {

			var className:String = getQualifiedClassName(subject);
			var key:String = createDictKeyFor(className);
			var cacheEntry:MatchCacheEntry = _typeMatchCache.itemFor(key);
			if(cacheEntry !== null) {
				return cacheEntry.isMatching;
			}

			var isMatching:Boolean = isMatchingType(className) || hasSuperClassMatch(subject);
			_typeMatchCache.add(key, new MatchCacheEntry(isMatching));

			return isMatching;
			//return isMatchingType(className) || hasSuperClassMatch(subject);
		}


		public function hasSuperClassMatch(subject:Object):Boolean {
			var types:XMLList = describeType(subject).*.@type;

			for each(var type:XML in types) {
				if(isMatchingType(type.toString())) {
					return true;
				}
			}

			return false;
		}


		private function isMatchingType(className:String):Boolean {

			return className.replace("::", ".") == _typeName;

			//if(_simpleMatch) {
			//	return className.split("::").pop() == _typeName;
			//}
			//
			//var key:String = createDictKeyFor(className);
			//var cacheEntry:MatchCacheEntry = _directMatchTypeMatchCache.itemFor(key);
			//if(cacheEntry !== null) {
			//	return cacheEntry.isMatching;
			//}
			//
			//var isMatching:Boolean = isTypeRegExMatching(className);
			//_directMatchTypeMatchCache.add(key, new MatchCacheEntry(isMatching));
			//return isMatching;
		}


		//private function isTypeRegExMatching(typeName:String):Boolean {
		//	typeName = typeName.replace("::", ".");
		//	return _typeMatcherRegEx.test(typeName);
		//}



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
