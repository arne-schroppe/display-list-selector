package net.wooga.uiengine.displaylistselector.classnamealias {
	import avmplus.getQualifiedClassName;

	public class AliasIsUnqualifiedClassNameInferenceStrategy implements IClassNameInferenceStrategy {




		public function doesObjectMatchAlias(alias:String, displayObject:Object):Boolean {
			return getQualifiedClassName(displayObject).split("::").pop() == alias;
		}
	}
}
