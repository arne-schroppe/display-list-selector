package net.wooga.fixtures.matcher {

	import org.hamcrest.Matcher;

	public function containsExactlyInNestedArray(count:int, itemMatcher:Matcher):Matcher
	{
		return new ExactCountInNestedArrayMatcher(count, itemMatcher);
	}
}
