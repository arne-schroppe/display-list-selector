package net.wooga.selectors.parser {

	import net.wooga.selectors.pseudoclasses.PseudoClass;

	public interface PseudoClassProvider {

		function hasPseudoClass(pseudoClassName:String):Boolean;
		function getPseudoClass(pseudoClassName:String):PseudoClass;

	}
}
