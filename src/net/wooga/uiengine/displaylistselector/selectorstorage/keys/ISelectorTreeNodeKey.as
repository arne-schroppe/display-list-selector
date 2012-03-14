package net.wooga.uiengine.displaylistselector.selectorstorage.keys {
	import net.wooga.uiengine.displaylistselector.parser.ParsedSelector;
	import net.wooga.uiengine.displaylistselector.selectoradapter.ISelectorAdapter;

	public interface ISelectorTreeNodeKey {
		function keyForSelector(parsedSelector:ParsedSelector):String;

		function keysForAdapter(adapter:ISelectorAdapter):Array;

		//function isKeyMatching(parsedSelector:ParsedSelector, key:*):Boolean;

		function selectorHasKey(parsedSelector:ParsedSelector):Boolean;

		function get nullKey():String;
	}
}
