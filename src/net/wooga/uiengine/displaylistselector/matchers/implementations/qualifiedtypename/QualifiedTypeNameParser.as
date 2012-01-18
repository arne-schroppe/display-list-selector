package net.wooga.uiengine.displaylistselector.matchers.implementations.qualifiedtypename {
	public class QualifiedTypeNameParser {

		private var _originalTypeName:String;
		private var _processedTypeRegEx:String;

		private static const NOT_FOUND:String = null;


		public function createTypeMatcherRegEx(typeName:String):RegExp {

			_originalTypeName = typeName;
			_processedTypeRegEx = "";
			var typeNameWithoutWhitespace:String = typeName.replace(/^\s*/, '');
			typeNameWithoutWhitespace = typeNameWithoutWhitespace.replace(/\s*$/, '');
			packagePart(typeNameWithoutWhitespace);

			_processedTypeRegEx += "$";
			return new RegExp(_processedTypeRegEx, "i");
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



		private function matchAndReturnNext(expression:RegExp, subject:String):String {
			var result:Object = expression.exec(subject);
			if (result == null || result.index != 0) {
				return NOT_FOUND;
			}

			return result[0] as String;
		}



	}
}
