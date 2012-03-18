package net.wooga.fixtures {

	import net.wooga.displaylistselector.selectoradapter.DisplayObjectSelectorAdapter;
	import net.wooga.displaylistselector.selectoradapter.ISelectorAdapter;

	public function getAdapterForObject(object:Object):ISelectorAdapter {
		var adapter:DisplayObjectSelectorAdapter = new DisplayObjectSelectorAdapter();
		adapter.register(object);

		return adapter;
	}
}
