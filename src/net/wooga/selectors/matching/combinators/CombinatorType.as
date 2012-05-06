package net.wooga.selectors.matching.combinators {

	public class CombinatorType {
		
		private var _value:String;

		public function CombinatorType(value:String) {
			_value = value;
		}

		public static const CHILD:CombinatorType = new CombinatorType("CHILD");
		public static const DESCENDANT:CombinatorType = new CombinatorType("DESCENDANT");
		public static const GENERAL_SIBLING:CombinatorType = new CombinatorType("GENERAL_SIBLING");
		public static const ADJACENT_SIBLING:CombinatorType = new CombinatorType("ADJACENT_SIBLING");

		
		public function toString():String {
			return _value;
		}
	}
}
