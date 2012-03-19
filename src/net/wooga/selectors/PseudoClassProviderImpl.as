package net.wooga.selectors {

	import net.wooga.selectors.parser.PseudoClassProvider;
	import net.wooga.selectors.pseudoclasses.PseudoClass;

	import org.as3commons.collections.Map;

	internal class PseudoClassProviderImpl implements PseudoClassProvider {

		private var _pseudoClassMap:Map = new Map();

		public function hasPseudoClass(pseudoClassName:String):Boolean {
			return _pseudoClassMap.hasKey(pseudoClassName);
		}

		public function getPseudoClass(pseudoClassName:String):PseudoClass {
			return _pseudoClassMap.itemFor(pseudoClassName);
		}

		internal function addPseudoClass(className:String, pseudoClass:PseudoClass):void {
			_pseudoClassMap.add(className, pseudoClass);
		}
	}
}
