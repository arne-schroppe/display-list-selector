package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class IsA implements PseudoClass {

		private var _className:String;
		private var _isQualifiedClassName:Boolean;



		public function setArguments(arguments:Array):void {
			if (arguments.length != 1) {
				throw new ArgumentError("Wrong argument count");
			}

			_className = arguments[0] as String;

			if(/^(\w|\$)+$/i.test(_className)) {
				_isQualifiedClassName = false;
			}
			else {
				_isQualifiedClassName = true;
			}
			
			if(_isQualifiedClassName && /^\s*((\w|\$)+\.)*(\w|\$)+\s*$/i.test(_className)) {
				_className = convertToDoubleColonForm(_className);
			}
		}


		private function convertToDoubleColonForm(typeName:String):String {
			var index:int = typeName.lastIndexOf(".");
			return typeName.substring(0, index) + "::" + typeName.substring(index + 1, typeName.length);
		}

		public function isMatching(adapter:SelectorAdapter):Boolean {
			if(_isQualifiedClassName) {
				return adapter.getQualifiedInterfacesAndClasses().indexOf(_className) != -1;
			}
			else {
				return adapter.getInterfacesAndClasses().indexOf(_className) != -1;
			}
		}
	}
}
