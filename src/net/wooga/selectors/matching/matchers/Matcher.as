package net.wooga.selectors.matching.matchers {

	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public interface Matcher {
		function isMatching(subject:SelectorAdapter):Boolean;
	}
}
