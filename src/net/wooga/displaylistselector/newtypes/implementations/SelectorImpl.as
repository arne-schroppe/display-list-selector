package net.wooga.displaylistselector.newtypes.implementations {

	import net.wooga.displaylistselector.ISpecificity;
	import net.wooga.displaylistselector.newtypes.*;

	public class SelectorImpl extends SelectorDescriptionImpl implements Selector {


		public function SelectorImpl(selectorString:String, specificity:ISpecificity) {
			super(selectorString, specificity);
		}

		public function isMatching(object:Object):Boolean {
			return false;
		}
	}
}
