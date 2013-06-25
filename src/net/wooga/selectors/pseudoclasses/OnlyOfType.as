package net.wooga.selectors.pseudoclasses {

	import flash.utils.getDefinitionByName;

	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class OnlyOfType implements IPseudoClass {


		//TODO (arneschroppe 08/04/2012) this is awfully slow
		public function isMatching(subject:ISelectorAdapter):Boolean {
			var count:int = 0;
			var SubjectType:Class = getDefinitionByName(subject.getQualifiedElementClassName()) as Class;
			var current:Object;

			var length:int = subject.getNumberOfElementsInContainer();
			for (var i:int = 0; i < length; ++i) {
				current = subject.getElementAtIndex(i);

				if (current is SubjectType) {
					++count;
				}
				
				if(count > 1) {
					return false;
				}
			}

			return true;
		}


		public function setArguments(arguments:Array):void {
			if (arguments.length != 0) {
				throw new ArgumentError("Wrong argument count");
			}
		}

	}
}
