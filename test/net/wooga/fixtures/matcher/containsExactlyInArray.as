package net.wooga.fixtures.matcher {
	import org.hamcrest.Matcher;

	public function containsExactlyInArray(count:int, itemMatcher:Matcher):Matcher
	{
		return new ExactCountInArrayMatcher(count, itemMatcher);
	}
}
