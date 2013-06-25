package net.wooga.selectors.specificity {
	public interface ISpecificity {


		function compare(other:ISpecificity):int;
		
		function get numberOfDigits():int;
		function digitAtPosition(position:int):int;

		function toString():String;
	}
}
