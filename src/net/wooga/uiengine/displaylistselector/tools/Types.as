package net.wooga.uiengine.displaylistselector.tools {
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	public class Types {
		public static function doesTypeHaveSuperClass(type:Class, implementedType:Class):Boolean {

			if(type == implementedType) {
				return true;
			}

			var extendedClasses:XMLList = describeType(type)..extendsClass.@type;
			return checkAgainstTypes(implementedType, extendedClasses);
		}


		public static function doesTypeImplementInterface(type:Class, implementedInterface:Class):Boolean {

			if(type == implementedInterface) {
				return true;
			}

			var extendedClasses:XMLList = describeType(type)..implementsInterface.@type;
			return checkAgainstTypes(implementedInterface, extendedClasses);
		}


		private static function checkAgainstTypes(requestedType:Class, typeList:XMLList):Boolean {
			var className:String = getQualifiedClassName(requestedType);
			for each(var thisClass:XML in typeList) {
				if(className == thisClass.toString()) {
					return true;
				}
			}

			return false;
		}

	}
}
