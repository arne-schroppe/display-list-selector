package net.wooga.fixtures {
	import net.wooga.uiengine.displaylistselector.selectoradapter.DisplayObjectSelectorAdapter;
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapterDelegate;

	public function getAdapterForObject(object:Object, delegate:ISelectorAdapterDelegate = null):ISelectorAdapter {
		var adapter:DisplayObjectSelectorAdapter = new DisplayObjectSelectorAdapter();
		adapter.register(object, delegate);

		return adapter;
	}
}
