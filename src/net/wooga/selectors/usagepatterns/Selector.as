package net.wooga.selectors.usagepatterns {

	public interface Selector extends SelectorDescription {

		function isMatching(object:Object):Boolean;

		//TODO (arneschroppe 16/04/2012) delete
		//function getMatchedObjectFor(object:Object):Object;

		//TODO (arneschroppe 16/04/2012) make this forward-compatible for more complex selections in the shadow tree
		//function isPseudoElement():Boolean;
		//function getPseudoElementName():String;

	}
}
