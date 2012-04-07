package net.wooga.selectors.pseudoclasses.fixtures {

	import flash.utils.Dictionary;

	import net.wooga.selectors.AdapterSource;

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class ProgrammableAdapterMap implements AdapterSource {

		public var map:Dictionary = new Dictionary();

		public function getAdapterForObject(object:Object):SelectorAdapter {
			return map[object];
		}
	}
}
