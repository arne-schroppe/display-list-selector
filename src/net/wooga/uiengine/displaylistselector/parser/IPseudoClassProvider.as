package net.wooga.uiengine.displaylistselector.parser {
	import net.wooga.uiengine.displaylistselector.pseudoclasses.IPseudoClass;

	public interface IPseudoClassProvider {

		function hasPseudoClass(pseudoClassName:String):Boolean;
		function getPseudoClass(pseudoClassName:String):IPseudoClass;

	}
}
