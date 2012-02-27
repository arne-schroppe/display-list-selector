package net.wooga.uiengine.displaylistselector.selectorstorage.keys {
	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public interface ISelectorTreeNodeKey {
		function keyForSelector(parsedSelector:ParsedSelector):*;

		function keyForAdapter(adapter:IStyleAdapter):*;

		//function isKeyMatching(parsedSelector:ParsedSelector, key:*):Boolean;

		function selectorHasKey(parsedSelector:ParsedSelector):Boolean;

		function get nullKey():*;
	}
}
