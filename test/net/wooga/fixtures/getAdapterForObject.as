package net.wooga.fixtures {
	import net.wooga.uiengine.displaylistselector.selectoradapter.DisplayObjectSelectorAdapter;
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	public function getAdapterForObject(object:Object):ISelectorAdapter {
		var adapter:DisplayObjectSelectorAdapter = new DisplayObjectSelectorAdapter();
		adapter.register(object);

		return adapter;
	}
}
