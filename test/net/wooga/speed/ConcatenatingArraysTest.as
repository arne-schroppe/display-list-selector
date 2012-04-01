package net.wooga.speed {

	public class ConcatenatingArraysTest {





		[Test]
		public function iterating_concatenate_or_individual_arrays():void {

			var iterations:int = 1000000;

			runSpeedTests([

				"individual arrays", individualArrays,
				"concatenated arrays", concatenatedArrays,
				"concatenated vectors", concatenatedVectors,
				"individual vectors", individualVectors,
				"individual vectors in array", individualVectorsInArray,

				"concatenated arrays for each", concatenatedArraysForEach,
				"individual arrays for each", individualArraysForEach,
				"concatenated vectors for each", concatenatedVectorsForEach,
				"individual vectors for each", individualVectorsForEach,
				"individual vectors in array for each", individualVectorsInArrayForEach
			],
					iterations);
		}


		private function concatenatedArrays():void {

			var result:int = 0;

			var arr1:Array = [1, 2, 3, 4, 5];
			var arr2:Array = [6, 7, 8, 9, 10];
			var arr3:Array = [11, 12, 13, 14, 15];

			var allArrays:Array = arr1.concat(arr2, arr3);

			var len:int = allArrays.length
			for(var i:int = 0; i < len; ++i) {
				result += allArrays[i];
			}
		}

		private function individualArrays():void {

			var result:int = 0;

			var arr1:Array = [1, 2, 3, 4, 5];
			var arr2:Array = [6, 7, 8, 9, 10];
			var arr3:Array = [11, 12, 13, 14, 15];

			var allArrays:Array = [arr1, arr2, arr3];

			var outerLen:int = allArrays.length
			for(var i:int = 0; i < outerLen; ++i) {
				var currentArray:Array = allArrays[i];
				var len:int = currentArray.length
				for(var j:int = 0; j < len; ++j) {
					result += currentArray[j];
				}
			}
		}



		private function concatenatedVectors():void {

			var result:int = 0;

			var arr1:Vector.<int> = new <int>[1, 2, 3, 4, 5];
			var arr2:Vector.<int> = new <int>[6, 7, 8, 9, 10];
			var arr3:Vector.<int> = new <int>[11, 12, 13, 14, 15];

			var allArrays:Vector.<int> = arr1.concat(arr2, arr3);

			var len:int = allArrays.length
			for(var i:int = 0; i < len; ++i) {
				result += allArrays[i];
			}
		}

		private function individualVectors():void {

			var result:int = 0;

			var arr1:Vector.<int> = new <int>[1, 2, 3, 4, 5];
			var arr2:Vector.<int> = new <int>[6, 7, 8, 9, 10];
			var arr3:Vector.<int> = new <int>[11, 12, 13, 14, 15];

			var allArrays:Vector.<Vector.<int>> = new <Vector.<int>>[arr1, arr2, arr3];

			var outerLen:int = allArrays.length
			for(var i:int = 0; i < outerLen; ++i) {
				var currentArray:Vector.<int> = allArrays[i];
				var len:int = currentArray.length
				for(var j:int = 0; j < len; ++j) {
					result += currentArray[j];
				}
			}
		}



		private function individualVectorsInArray():void {

			var result:int = 0;

			var arr1:Vector.<int> = new <int>[1, 2, 3, 4, 5];
			var arr2:Vector.<int> = new <int>[6, 7, 8, 9, 10];
			var arr3:Vector.<int> = new <int>[11, 12, 13, 14, 15];

			var allArrays:Array = [arr1, arr2, arr3];

			var outerLen:int = allArrays.length;
			for(var i:int = 0; i < outerLen; ++i) {
				var currentArray:Vector.<int> = allArrays[i];
				var len:int = currentArray.length
				for(var j:int = 0; j < len; ++j) {
					result += currentArray[j];
				}
			}
		}



		private function concatenatedArraysForEach():void {

			var result:int = 0;

			var arr1:Array = [1, 2, 3, 4, 5];
			var arr2:Array = [6, 7, 8, 9, 10];
			var arr3:Array = [11, 12, 13, 14, 15];

			var allArrays:Array = arr1.concat(arr2, arr3);

			for each(var num:int in allArrays) {
				result += num;
			}
		}

		private function individualArraysForEach():void {

			var result:int = 0;

			var arr1:Array = [1, 2, 3, 4, 5];
			var arr2:Array = [6, 7, 8, 9, 10];
			var arr3:Array = [11, 12, 13, 14, 15];

			var allArrays:Array = [arr1, arr2, arr3];

			for each (var currentArray:Array in allArrays ) {
				for each(var num:int in currentArray) {
					result += num;
				}
			}
		}



		private function concatenatedVectorsForEach():void {

			var result:int = 0;

			var arr1:Vector.<int> = new <int>[1, 2, 3, 4, 5];
			var arr2:Vector.<int> = new <int>[6, 7, 8, 9, 10];
			var arr3:Vector.<int> = new <int>[11, 12, 13, 14, 15];

			var allArrays:Vector.<int> = arr1.concat(arr2, arr3);

			for each(var num:int in allArrays) {
				result += num;
			}
		}

		private function individualVectorsForEach():void {

			var result:int = 0;

			var arr1:Vector.<int> = new <int>[1, 2, 3, 4, 5];
			var arr2:Vector.<int> = new <int>[6, 7, 8, 9, 10];
			var arr3:Vector.<int> = new <int>[11, 12, 13, 14, 15];

			var allArrays:Vector.<Vector.<int>> = new <Vector.<int>>[arr1, arr2, arr3];

			for each (var currentArray:Vector.<int> in allArrays ) {
				for each(var num:int in currentArray) {
					result += num;
				}
			}
		}



		private function individualVectorsInArrayForEach():void {

			var result:int = 0;

			var arr1:Vector.<int> = new <int>[1, 2, 3, 4, 5];
			var arr2:Vector.<int> = new <int>[6, 7, 8, 9, 10];
			var arr3:Vector.<int> = new <int>[11, 12, 13, 14, 15];

			var allArrays:Array = [arr1, arr2, arr3];

			for each (var currentArray:Vector.<int> in allArrays ) {
				for each(var num:int in currentArray) {
					result += num;
				}
			}
		}
	}
}
