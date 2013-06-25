package net.wooga.selectors.adaptermap {

	import flash.utils.Dictionary;

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class SelectorAdapterMap implements ISelectorAdapterSource{

		private var _objectToSelectorAdapterMap:Dictionary = new Dictionary();

		public function getSelectorAdapterForObject(object:Object):ISelectorAdapter {
			return _objectToSelectorAdapterMap[object];
		}

		public function hasAdapterForObject(object:Object):Boolean {
			return object in _objectToSelectorAdapterMap;
		}

		public function setAdapterForObject(object:Object, adapter:ISelectorAdapter):void {
			_objectToSelectorAdapterMap[object] = adapter;
		}

		public function removeAdapterForObject(object:Object):void {
			if(!(object in _objectToSelectorAdapterMap)) {
				return;
			}

			var adapter:ISelectorAdapter = _objectToSelectorAdapterMap[object];
			adapter.unregister();
			delete _objectToSelectorAdapterMap[object];
		}

	}
}
