package net.wooga.speed {

	import flash.utils.getTimer;

	import flexunit.framework.Test;

	import net.digitalprimates.fluint.monitor.TestMonitor;

	import net.digitalprimates.fluint.ui.TestEnvironment;

	import net.digitalprimates.fluint.ui.TestRunner;

	import org.flexunit.asserts.assertTrue;

	import org.flexunit.asserts.fail;
	import org.fluint.uiImpersonation.UIImpersonator;

	public class GenericSpeedTests {

		[Test]
		public function concat_or_apply_push():void {

			var iterations:int = 1000000;

			runSpeedTests(["concat", concatTest, "push.apply", pushApplyTest], iterations);
		}




		private function concatTest():void {
			var firstVector:Array;
			var secondVector:Array;

			firstVector = ["a", "b", "c", "d", "e", "f"];
			secondVector = ["1", "2", "3", "4", "5", "6"];

			firstVector.concat(secondVector);
		}

		private function pushApplyTest():void {
			var firstVector:Array;
			var secondVector:Array;

			firstVector = ["a", "b", "c", "d", "e", "f"];
			secondVector = ["1", "2", "3", "4", "5", "6"];

			firstVector.push.apply(firstVector, secondVector);
		}









	}
}
