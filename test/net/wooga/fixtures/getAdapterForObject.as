package net.wooga.fixtures {
	import net.wooga.uiengine.displaylistselector.styleadapter.DisplayObjectStyleAdapter;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public function getAdapterForObject(object:Object):IStyleAdapter {
		var adapter:DisplayObjectStyleAdapter = new DisplayObjectStyleAdapter();
		adapter.register(object);

		return adapter;
	}
}
