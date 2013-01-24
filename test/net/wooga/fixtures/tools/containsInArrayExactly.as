package net.wooga.fixtures.tools {

	import org.hamcrest.Matcher;

	public function containsInArrayExactly(count:int, itemMatcher:Matcher):Matcher {
		return new ExactCountInArrayMatcher(count, itemMatcher);
	}
}
