package net.wooga.selectors.matching.matchers.implementations {

	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.matching.matchers.implementations.combinators.MatcherFamily;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class TypeNameMatcher implements IMatcher {

		private var _matchAny:Boolean = false;
		private var _typeName:String;

		private var _classNameOnly:Boolean;


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


		public function isMatching(subject:ISelectorAdapter):Boolean {
			return _matchAny || matchesType(subject);

		}


		private function matchesType(adapter:ISelectorAdapter):Boolean {

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


		public function get matcherFamily():MatcherFamily {
			return MatcherFamily.SIMPLE_MATCHER;
		}
	}
}

