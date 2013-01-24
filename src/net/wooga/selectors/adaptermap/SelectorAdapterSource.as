package net.wooga.selectors.adaptermap {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public interface SelectorAdapterSource {
		function getSelectorAdapterForObject(object:Object):SelectorAdapter;
	}
}
