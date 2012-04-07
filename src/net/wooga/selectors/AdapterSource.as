package net.wooga.selectors {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public interface AdapterSource {
		function getAdapterForObject(object:Object):SelectorAdapter;
	}
}
