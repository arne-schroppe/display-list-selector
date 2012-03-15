package net.wooga.displaylistselector {
	public interface ISpecificity {

		function toNumber():Number;

		function isLessThan(other:ISpecificity):Boolean;
		function isGreaterThan(other:ISpecificity):Boolean;
		function isEqualTo(other:ISpecificity):Boolean;

		function compare(other:ISpecificity):int;

		function toString():String;

	}
}
