package net.wooga.selectors.matching.matchers.implementations {

	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	//TODO (arneschroppe 19/3/12) operations in this class take too much time, especially isMatching and calls to addFromCollection
	public class TypeNameMatcher implements IMatcher {

		private var _matchAny:Boolean = false;
		private var _typeName:String;

		private var _classNameOnly:Boolean;

		//TODO (arneschroppe 23/2/12) always use the :: notation internally
		public function TypeNameMatcher(typeName:String) {
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

			if(_classNameOnly) {
				return adapter.getElementClassName() == _typeName;
			}
			else {
				return adapter.getQualifiedElementClassName() == _typeName;
			}
		}


		public function get typeName():String {
			return _typeName;
		}
	}
}

