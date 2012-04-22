package net.wooga.selectors.specificity {
	public interface Specificity {


		function compare(other:Specificity):int;
		
		function get numberOfDigits():int;
		function digitAtPosition(position:int):int;

		function toString():String;
	}
}
