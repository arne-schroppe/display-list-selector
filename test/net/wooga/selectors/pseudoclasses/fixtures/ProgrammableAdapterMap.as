package net.wooga.selectors.pseudoclasses.fixtures {

	import flash.utils.Dictionary;

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class ProgrammableAdapterMap implements AdapterSource {

		public var map:Dictionary = new Dictionary();

		public function getAdapterForObject(object:Object):ISelectorAdapter {
			return map[object];
		}
	}
}
