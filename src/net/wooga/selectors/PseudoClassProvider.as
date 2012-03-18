package net.wooga.selectors {

	import net.wooga.selectors.parser.IPseudoClassProvider;
	import net.wooga.selectors.pseudoclasses.IPseudoClass;

	import org.as3commons.collections.Map;

	internal class PseudoClassProvider implements IPseudoClassProvider {

		private var _pseudoClassMap:Map = new Map();

		public function hasPseudoClass(pseudoClassName:String):Boolean {
			return _pseudoClassMap.hasKey(pseudoClassName);
		}

		public function getPseudoClass(pseudoClassName:String):IPseudoClass {
			return _pseudoClassMap.itemFor(pseudoClassName);
		}

		internal function addPseudoClass(className:String, pseudoClass:IPseudoClass):void {
			_pseudoClassMap.add(className, pseudoClass);
		}
	}
}
