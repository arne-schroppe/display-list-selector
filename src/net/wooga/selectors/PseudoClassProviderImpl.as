package net.wooga.selectors {

	import flash.utils.Dictionary;

	import net.wooga.selectors.parser.PseudoClassProvider;
	import net.wooga.selectors.pseudoclasses.PseudoClass;

	internal class PseudoClassProviderImpl implements PseudoClassProvider {

		private var _pseudoClassMap:Dictionary = new Dictionary();

		public function hasPseudoClass(pseudoClassName:String):Boolean {
			return _pseudoClassMap.hasOwnProperty(pseudoClassName);
		}

		public function getPseudoClass(pseudoClassName:String):PseudoClass {
			return _pseudoClassMap[pseudoClassName];
		}

		internal function addPseudoClass(className:String, pseudoClass:PseudoClass):void {
			_pseudoClassMap[className] = pseudoClass;
		}
	}
}
