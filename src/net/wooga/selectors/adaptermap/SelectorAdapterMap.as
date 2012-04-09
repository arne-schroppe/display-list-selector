package net.wooga.selectors.adaptermap {

	import flash.utils.Dictionary;

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	import org.hamcrest.object.isFalse;

	public class SelectorAdapterMap implements SelectorAdapterSource{

		private var _objectToSelectorAdapterMap:Dictionary = new Dictionary();

		public function getSelectorAdapterForObject(object:Object):SelectorAdapter {
			return _objectToSelectorAdapterMap[object];
		}

		public function hasAdapterForObject(object:Object):Boolean {
			return object in _objectToSelectorAdapterMap;
		}

		public function setAdapterForObject(object:Object, adapter:SelectorAdapter):void {
			_objectToSelectorAdapterMap[object] = adapter;
		}

		public function removeAdapterForObject(object:Object):void {
			if(!(object in _objectToSelectorAdapterMap)) {
				return;
			}

			var adapter:SelectorAdapter = _objectToSelectorAdapterMap[object];
			adapter.unregister();
			delete _objectToSelectorAdapterMap[object];
		}

	}
}
