package net.wooga.speed {

	import flash.system.System;
	import flash.utils.getTimer;

	public function runSpeedTests(tests:Array, iterations:int):void {
		var i:int;

		var times:Array = [];
		var timeBefore:int
		var timeAfter:int;

		for (var j:int = 1; j < tests.length; j+=2) {

			var currentTest:Function = tests[j];

			System.gc();
			timeBefore = getTimer();
			for(i = 0; i < iterations; ++i) {
				currentTest();
			}
			timeAfter = getTimer();

			times.push(timeAfter - timeBefore);
		}


		for(i = 0; i < times.length; ++i) {

			trace("'" + tests[i*2] + "': " + times[i], true);
		}
	}
}
