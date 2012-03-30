package net.wooga.fixtures.matcher {
	import org.as3commons.collections.framework.IIterable;
	import org.hamcrest.Description;
	import org.hamcrest.Matcher;
	import org.hamcrest.TypeSafeDiagnosingMatcher;

	public class ExactCountInArrayMatcher extends TypeSafeDiagnosingMatcher{
		private var _matcher:Matcher;
		private var _expectedCount:int;

		public function ExactCountInArrayMatcher(expectedCount:int, matcher:Matcher) {
			super(Object);
			_matcher = matcher;
			_expectedCount = expectedCount;


		}


		override public function matchesSafely(collection:Object, description:Description):Boolean {

			var array:Array = collection as Array;
			if(!array) {
				description.appendText("Object is not Array");
				return false;
			}

			var actualMatchCount:int = 0;
			for each(var item:* in array) {

				if (_matcher.matches(item))
				{
					++actualMatchCount;

				}
			}

			if(actualMatchCount !== _expectedCount) {
				description.appendText(actualMatchCount + " items matched ");
				return false;
			}

			return true;
		}


		override public function describeTo(description:Description):void {
			description.appendText("exactly " + _expectedCount + " items in collection matching ").appendDescriptionOf(_matcher);
		}
	}
}
