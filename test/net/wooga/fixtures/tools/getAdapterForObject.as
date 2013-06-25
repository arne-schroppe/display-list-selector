package net.wooga.fixtures.tools {

	import net.wooga.selectors.displaylist.DisplayObjectSelectorAdapter;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public function getAdapterForObject(object:Object):ISelectorAdapter {
		var adapter:DisplayObjectSelectorAdapter = new DisplayObjectSelectorAdapter();
		adapter.register(object);

		return adapter;
	}
}
