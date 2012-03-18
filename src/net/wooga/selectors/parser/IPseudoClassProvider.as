package net.wooga.selectors.parser {

	import net.wooga.selectors.pseudoclasses.IPseudoClass;

	public interface IPseudoClassProvider {

		function hasPseudoClass(pseudoClassName:String):Boolean;
		function getPseudoClass(pseudoClassName:String):IPseudoClass;

	}
}
