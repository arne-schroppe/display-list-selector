package net.wooga.selectors.pseudoclasses.provider {

	public class PseudoClassMapEntry {

		public var type:Class;
		public var arguments:Array;


		public function PseudoClassMapEntry(type:Class, arguments:Array) {
			this.type = type;
			this.arguments = arguments;
		}
	}

}
