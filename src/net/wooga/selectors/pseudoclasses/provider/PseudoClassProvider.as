package net.wooga.selectors.pseudoclasses.provider {

	import flash.utils.Dictionary;

	import net.wooga.selectors.parser.IPseudoClassProvider;
	import net.wooga.selectors.pseudoclasses.IPseudoClass;

	public class PseudoClassProvider implements IPseudoClassProvider {

		private var _pseudoClassMap:Dictionary = new Dictionary();

		public function hasPseudoClass(pseudoClassName:String):Boolean {
			return _pseudoClassMap.hasOwnProperty(pseudoClassName);
		}

		public function getPseudoClass(pseudoClassName:String):IPseudoClass {

			var entry:PseudoClassMapEntry = _pseudoClassMap[pseudoClassName];

			return InstantiationTool.instantiate(entry.type, entry.arguments) as IPseudoClass;
		}

		public function addPseudoClass(className:String, pseudoClass:Class, constructorArguments:Array):void {
			_pseudoClassMap[className] = new PseudoClassMapEntry(pseudoClass, constructorArguments);
		}
	}
}


