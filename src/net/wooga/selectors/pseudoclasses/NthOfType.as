package net.wooga.selectors.pseudoclasses {

	import net.wooga.selectors.AdapterSource;
	import net.wooga.selectors.pseudoclasses.nthchildren.NthOfX;
	import net.wooga.selectors.selectoradapter.SelectorAdapter;

	public class NthOfType extends NthOfX {


		private var _adapterSource:AdapterSource;


		public function NthOfType(adapterSource:AdapterSource) {
			_adapterSource = adapterSource;
		}

		override protected function indexOfObject(subject:SelectorAdapter):int {
			var index:int = 0;
			var subjectType:String = subject.getQualifiedElementClassName();
			var current:Object;
			var currentAdapter:SelectorAdapter;

			var length:int = subject.getNumberOfElements();
			for (var i:int = 0; i < length; ++i) {
				current = subject.getElementAtIndex(i);

				if (current == subject.getAdaptedElement()) {
					return index;
				}

				currentAdapter = _adapterSource.getAdapterForObject(current);
				if (currentAdapter && currentAdapter.getQualifiedElementClassName() == subjectType) {
					++index;
				}
			}

			throw new Error("object is not child of it's parent");
		}
	}
}
