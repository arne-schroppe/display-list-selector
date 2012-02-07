package net.wooga.uiengine.displaylistselector.matching.matchers.implementations {
	import net.wooga.uiengine.displaylistselector.matching.*;
	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.IExternalPropertySource;
	import net.wooga.uiengine.displaylistselector.matching.matchers.IMatcher;

	public class PropertyFilterEqualsMatcher implements IMatcher {
		private var _property:String;
		private var _value:String;
		private var _externalPropertySource:IExternalPropertySource;

		public function PropertyFilterEqualsMatcher(externalPropertySource:IExternalPropertySource, property:String, value:String) {
			_externalPropertySource = externalPropertySource;
			_property = property;
			_value = value;
		}

		public function isMatching(subject:DisplayObject):Boolean {
			if (!(_property in subject)) {
				return getExternalProperty(subject);
			} else {
				return getObjectProperty(subject);
			}
		}

		private function getObjectProperty(subject:DisplayObject):Boolean {
			if (subject[_property] == _value) {
				return true;
			}

			return false;
		}

		private function getExternalProperty(subject:DisplayObject):Boolean {
			var currentValue:String = _externalPropertySource.stringValueForProperty(subject, _property);
			if (currentValue == _value) {
				return true;
			}

			return false;
		}


	}
}
