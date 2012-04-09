package net.wooga.selectors {

	public interface PseudoElementSource {

		function pseudoElementForIdentifier(matchedObject:Object, identifier:String):Object;
		
	}
}
