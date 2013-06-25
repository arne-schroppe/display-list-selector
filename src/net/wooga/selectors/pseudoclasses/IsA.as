package net.wooga.selectors.pseudoclasses {

	import flash.utils.Dictionary;

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class IsA implements IPseudoClass {

		private var _typeName:String;
		private var _isQualifiedClassName:Boolean;

		private var _matchCache:Dictionary = new Dictionary();


		public function setArguments(arguments:Array):void {
			if (arguments.length != 1) {
				throw new ArgumentError("Wrong argument count");
			}

			_typeName = String(arguments[0]).replace(/\s/g, "");

			if(/^(\w|\$)+$/i.test(_typeName)) {
				_isQualifiedClassName = false;
			}
			else {
				_isQualifiedClassName = true;
			}

			if(_isQualifiedClassName && /^\s*((\w|\$)+\.)+(\w|\$)+\s*$/i.test(_typeName)) {
				_typeName = convertToDoubleColonForm(_typeName);
			}
		}


		private function convertToDoubleColonForm(typeName:String):String {
			var index:int = typeName.lastIndexOf(".");
			return typeName.substring(0, index) + "::" + typeName.substring(index + 1, typeName.length);
		}

		public function isMatching(adapter:ISelectorAdapter):Boolean {
			if(_isQualifiedClassName) {
				return matchQualified(adapter)
			} else {
				return matchUnqualified(adapter);
			}
		}

		public function get typeName():String {
			return _typeName;
		}


		private function matchQualified(adapter:ISelectorAdapter):Boolean {

			var cacheKey:String = createCacheKey(adapter.getQualifiedElementClassName());
			if(_matchCache[cacheKey] !== undefined) {
				return _matchCache[cacheKey];
			}

			var result:Boolean = adapter.getQualifiedElementClassName() == _typeName || adapter.getQualifiedInterfacesAndClasses().indexOf(_typeName) != -1;
			_matchCache[cacheKey] = result;

			return result;
		}



		private function matchUnqualified(adapter:ISelectorAdapter):Boolean {

			var cacheKey:String = createCacheKey(adapter.getQualifiedElementClassName());
			if(_matchCache[cacheKey] !== undefined) {
				return _matchCache[cacheKey];
			}

			var result:Boolean = adapter.getElementClassName() == _typeName || adapter.getInterfacesAndClasses().indexOf(_typeName) != -1;
			_matchCache[cacheKey] = result;

			return result;
		}



		private function createCacheKey(className:String):String {
			return _typeName + "&" + className;
		}
	}
}
