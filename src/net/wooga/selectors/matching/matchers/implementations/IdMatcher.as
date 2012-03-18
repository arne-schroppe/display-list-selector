package net.wooga.selectors.matching.matchers.implementations {

	import net.wooga.selectors.matching.matchers.IMatcher;
	import net.wooga.selectors.selectoradapter.ISelectorAdapter;

	public class IdMatcher implements IMatcher {
		private var _id:String;

		public function IdMatcher(id:String) {
			_id = id;
		}

		public function isMatching(subject:ISelectorAdapter):Boolean {
			return subject.getId() == _id;
		}

		public function get id():String {
			return _id;
		}
	}
}
