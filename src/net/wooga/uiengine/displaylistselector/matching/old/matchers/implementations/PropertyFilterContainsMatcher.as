package net.wooga.uiengine.displaylistselector.matching.old.matchers.implementations {
	import net.wooga.uiengine.displaylistselector.matching.*;
	import flash.display.DisplayObject;

	import net.wooga.uiengine.displaylistselector.IExternalPropertySource;
	import net.wooga.uiengine.displaylistselector.matching.old.matchers.IMatcher;

	import org.as3commons.collections.Set;

	public class PropertyFilterContainsMatcher implements IMatcher {
		private var _property:String;
		private var _value:String;
		private var _externalPropertySource:IExternalPropertySource;

		public function PropertyFilterContainsMatcher(externalPropertySource:IExternalPropertySource, property:String, value:String) {
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
			var collection:Set = subject[_property] as Set;
			if (collection && collection.has(_value)) {
				return true;
			}

			return false;
		}

		private function getExternalProperty(subject:DisplayObject):Boolean {
			var collection:Set = _externalPropertySource.collectionValueForProperty(subject, _property);

			if (collection && collection.has(_value)) {
				return true;
			}

			return false;
		}
	}
}
