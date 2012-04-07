package net.wooga.selectors.pseudoclasses {

	import flash.utils.getDefinitionByName;

	import net.wooga.selectors.pseudoclasses.nthchildren.NthOfX;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class NthOfType extends NthOfX {


		override protected function indexOfObject(subject:SelectorAdapter):int {
			var index:int = 0;
			var SubjectType:Class = getDefinitionByName(subject.getQualifiedElementClassName()) as Class;
			var current:Object;

			var length:int = subject.getNumberOfElementsInContainer();
			for (var i:int = 0; i < length; ++i) {
				current = subject.getElementAtIndex(i);

				if (current == subject.getAdaptedElement()) {
					return index;
				}

				if (current is SubjectType) {
					++index;
				}
			}

			throw new Error("object is not child of it's parent");
		}
	}
}
