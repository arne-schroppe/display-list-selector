package net.wooga.uiengine.displaylistselector.matching.old.matchers.implementations {
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.IMatcher;
	import net.wooga.uiengine.displaylistselector.styleadapter.IStyleAdapter;

	public class HasIdMatcher implements IMatcher {
		private var _id:String;

		public function HasIdMatcher(id:String) {
			_id = id;
		}

		public function isMatching(subject:IStyleAdapter):Boolean {
			return subject.getId() == _id;
		}
	}
}
