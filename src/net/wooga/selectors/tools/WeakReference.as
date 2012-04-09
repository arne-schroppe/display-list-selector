package net.wooga.selectors.tools {

	import flash.utils.Dictionary;

	public class WeakReference {

		private var _reference:Dictionary;

		public function WeakReference(target:*) {
			_reference = new Dictionary(true);
			_reference[target] = true;
		}


		public function get referencedObject():* {
			for (var target:* in _reference) {
				return target;
			}
			return undefined;
		}
	}
}
