package net.wooga.fixtures {
	import org.hamcrest.Matcher;

	public function containsInArrayExactly(count:int, itemMatcher:Matcher):Matcher {
		return new ExactCountInArrayMatcher(count, itemMatcher);
	}
}
