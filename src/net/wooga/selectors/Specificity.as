package net.wooga.selectors {
	public interface Specificity {

		function toNumber():Number;

		function isLessThan(other:Specificity):Boolean;
		function isGreaterThan(other:Specificity):Boolean;
		function isEqualTo(other:Specificity):Boolean;

		function compare(other:Specificity):int;

		function toString():String;

	}
}
