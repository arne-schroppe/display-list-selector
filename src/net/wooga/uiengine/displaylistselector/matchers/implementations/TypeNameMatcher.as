package net.wooga.uiengine.displaylistselector.matchers.implementations {

	import flash.display.DisplayObject;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	import net.wooga.uiengine.displaylistselector.matchers.*;

	public class TypeNameMatcher implements IMatcher {

		private var _matchAny:Boolean = false;
		private var _onlyMatchImmediateClassType:Boolean;
		private var _typeMatcherRegEx:RegExp;
		
		private var _processedTypeRegEx:String;
		private var _originalTypeName:String;

		private static const NOT_FOUND:String = null;
		
		public function TypeNameMatcher(typeName:String, onlyMatchImmediateClassType:Boolean = true) {

			_originalTypeName = typeName;

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
			_typeMatcherRegEx = createTypeMatcherRegEx(normalizedName);
			
			// fixtures\.package2\.TestSpritePack$

		}


		private function matchAndReturnNext(expression:RegExp, subject:String):String {
			var result:Object = expression.exec(subject);
			if (result == null || result.index != 0) {
				return NOT_FOUND;
			}

			return result[0] as String;
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

			return isMatchingTypeName(getQualifiedClassName(subject)) || isAnySuperClassMatchingTypeName(subject);

		}

		//TODO (arneschroppe 17/1/12) maybe we can cache these results
		private function isAnySuperClassMatchingTypeName(subject:DisplayObject):Boolean {

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


		private function createTypeMatcherRegEx(typeName:String):RegExp {

			_processedTypeRegEx = "";
			var typeNameWithoutWhitespace:String = typeName.replace(/^\s*/, '');
			typeNameWithoutWhitespace = typeNameWithoutWhitespace.replace(/\s*$/, '');
			packagePart(typeNameWithoutWhitespace);

			_processedTypeRegEx += "$";
			trace(_processedTypeRegEx);

			return new RegExp(_processedTypeRegEx);

		}

		private function packagePart(input:String):void {
			var matchResult:String;
			if((matchResult = matchAndReturnNext(/\w+/, input)) !== NOT_FOUND ) {
				_processedTypeRegEx += matchResult;
			}
			else if((matchResult = matchAndReturnNext(/\*/, input)) !== NOT_FOUND ) {
				_processedTypeRegEx += "\\w*";
			}
			else {
				malformed();
			}


			var rest:String = input.substring(matchResult.length);

			if(rest.length > 0) {
				delimiter(rest);
			}
		}


		private function delimiter(input:String):void {
			var matchResult:String;
			if((matchResult = matchAndReturnNext(/\./, input)) !== NOT_FOUND ) {
				_processedTypeRegEx += "\\.";
			}
			else {
				malformed();
			}

			var rest:String = input.substring(matchResult.length);
			packagePart(rest);
		}


		private function malformed():void {
			throw new ArgumentError("Malformed type identifier: " + _originalTypeName);
		}
	}
}
