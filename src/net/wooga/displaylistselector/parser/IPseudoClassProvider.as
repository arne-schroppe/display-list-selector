package net.wooga.displaylistselector.parser {

	import net.wooga.displaylistselector.pseudoclasses.IPseudoClass;

	public interface IPseudoClassProvider {

		function hasPseudoClass(pseudoClassName:String):Boolean;
		function getPseudoClass(pseudoClassName:String):IPseudoClass;

	}
}
