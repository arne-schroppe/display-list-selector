package net.wooga.uiengine.displaylistselector.pseudoclasses {

	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import net.wooga.uiengine.displaylistselector.pseudoclasses.nthchildren.NthOfX;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public class NthLastOfType extends NthOfX {

		override protected function indexOfObject(subject:IStyleAdapter):int {
			var index:int = 0;
			var SubjectType:Class = getDefinitionByName(getQualifiedClassName(subject.getAdaptedElement())) as Class;
			var current:Object;

			for(var i:int = subject.getNumberOfElementsInContainer()-1; i>=0; --i) {
				current = subject.getSiblingElementAtIndex(i);

				if(current == subject.getAdaptedElement()) {
					return index;
				}

				if(current is SubjectType) {
					++index;
				}
			}

			throw new Error("object is not child of it's parent");
		}


	}
}
