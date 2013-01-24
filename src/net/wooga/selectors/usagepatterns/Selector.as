package net.wooga.selectors.usagepatterns {

	public interface Selector extends SelectorDescription {

		function isMatching(object:Object):Boolean;
	}
}
