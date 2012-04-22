package net.wooga.selectors.specificity {
	public interface Specificity {


		function compare(other:Specificity):int;
		
		function get positions():int;
		function digitAtPosition(position:int):int;

		function toString():String;
	}
}
