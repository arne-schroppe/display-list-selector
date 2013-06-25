package net.wooga.selectors.adaptermap {

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public interface ISelectorAdapterSource {
		function getSelectorAdapterForObject(object:Object):ISelectorAdapter;
	}
}
