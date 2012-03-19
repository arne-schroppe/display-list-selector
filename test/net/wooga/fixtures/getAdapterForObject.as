package net.wooga.fixtures {

	import net.wooga.selectors.displaylist.DisplayObjectSelectorAdapter;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public function getAdapterForObject(object:Object):SelectorAdapter {
		var adapter:DisplayObjectSelectorAdapter = new DisplayObjectSelectorAdapter();
		adapter.register(object);

		return adapter;
	}
}
