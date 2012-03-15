package net.wooga.displaylistselector.parser {
	import org.hamcrest.assertThat;
	import org.hamcrest.number.greaterThan;
	import org.hamcrest.number.lessThan;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;

	public class SpecificityTest {


		[Test]
		public function testIsGreaterThan():void {

			var smallerSpec:Specificity = specWith(1, 10, 0, 0, 0);

			var higherSpec:Specificity = specWith(2, 6, 0, 0, 0);

			assertThat(higherSpec.isGreaterThan(smallerSpec), isTrue());
			assertThat(higherSpec.isLessThan(smallerSpec), isFalse());




			smallerSpec = specWith(0, 10, 0, 0, 0);
			higherSpec = specWith(1, 0, 0, 0, 0);

			assertThat(higherSpec.isGreaterThan(smallerSpec), isTrue());
			assertThat(higherSpec.isLessThan(smallerSpec), isFalse());



			smallerSpec = specWith(0, 0, 5, 0, 0);
			higherSpec = specWith(0, 1, 0, 0, 0);

			assertThat(higherSpec.isGreaterThan(smallerSpec), isTrue());
			assertThat(higherSpec.isLessThan(smallerSpec), isFalse());



			assertThat(specWith(2, 0, 0, 0, 0).isGreaterThan(specWith(1, 0, 0, 0, 0)), isTrue());
			assertThat(specWith(0, 2, 0, 0, 0).isGreaterThan(specWith(0, 1, 0, 0, 0)), isTrue());
			assertThat(specWith(0, 0, 2, 0, 0).isGreaterThan(specWith(0, 0, 1, 0, 0)), isTrue());
			assertThat(specWith(0, 0, 0, 2, 0).isGreaterThan(specWith(0, 0, 0, 1, 0)), isTrue());
			assertThat(specWith(0, 0, 0, 0, 2).isGreaterThan(specWith(0, 0, 0, 0, 1)), isTrue());



			assertThat(specWith(1, 0, 0, 0, 0).isGreaterThan(specWith(1, 0, 0, 0, 0)), isFalse());
			assertThat(specWith(0, 1, 0, 0, 0).isGreaterThan(specWith(0, 1, 0, 0, 0)), isFalse());
			assertThat(specWith(0, 0, 1, 0, 0).isGreaterThan(specWith(0, 0, 1, 0, 0)), isFalse());
			assertThat(specWith(0, 0, 0, 1, 0).isGreaterThan(specWith(0, 0, 0, 1, 0)), isFalse());
			assertThat(specWith(0, 0, 0, 0, 1).isGreaterThan(specWith(0, 0, 0, 0, 1)), isFalse());


			assertThat(specWith(2, 0, 0, 0, 0).isGreaterThan(specWith(3, 0, 0, 0, 0)), isFalse());
			assertThat(specWith(0, 2, 0, 0, 0).isGreaterThan(specWith(0, 3, 0, 0, 0)), isFalse());
			assertThat(specWith(0, 0, 2, 0, 0).isGreaterThan(specWith(0, 0, 3, 0, 0)), isFalse());
			assertThat(specWith(0, 0, 0, 2, 0).isGreaterThan(specWith(0, 0, 0, 3, 0)), isFalse());
			assertThat(specWith(0, 0, 0, 0, 2).isGreaterThan(specWith(0, 0, 0, 0, 3)), isFalse());

		}


		[Test]
		public function testIsLessThan():void {

			var smallerSpec:Specificity = specWith(1, 10, 0, 0, 0);

			var higherSpec:Specificity = specWith(2, 6, 0, 0, 0);

			assertThat(smallerSpec.isLessThan(higherSpec), isTrue());
			assertThat(smallerSpec.isGreaterThan(higherSpec), isFalse());

			smallerSpec = specWith(0, 10, 0, 0, 0);
			higherSpec = specWith(1, 0, 0, 0, 0);

			assertThat(smallerSpec.isLessThan(higherSpec), isTrue());
			assertThat(smallerSpec.isGreaterThan(higherSpec), isFalse());


			smallerSpec = specWith(0, 0, 5, 0, 0);

			higherSpec = specWith(0, 1, 0, 0, 0);

			assertThat(smallerSpec.isLessThan(higherSpec), isTrue());
			assertThat(smallerSpec.isGreaterThan(higherSpec), isFalse());




			assertThat(specWith(1, 0, 0, 0, 0).isLessThan(specWith(2, 0, 0, 0, 0)), isTrue());
			assertThat(specWith(0, 1, 0, 0, 0).isLessThan(specWith(0, 2, 0, 0, 0)), isTrue());
			assertThat(specWith(0, 0, 1, 0, 0).isLessThan(specWith(0, 0, 2, 0, 0)), isTrue());
			assertThat(specWith(0, 0, 0, 1, 0).isLessThan(specWith(0, 0, 0, 2, 0)), isTrue());
			assertThat(specWith(0, 0, 0, 0, 1).isLessThan(specWith(0, 0, 0, 0, 2)), isTrue());



			assertThat(specWith(1, 0, 0, 0, 0).isLessThan(specWith(1, 0, 0, 0, 0)), isFalse());
			assertThat(specWith(0, 1, 0, 0, 0).isLessThan(specWith(0, 1, 0, 0, 0)), isFalse());
			assertThat(specWith(0, 0, 1, 0, 0).isLessThan(specWith(0, 0, 1, 0, 0)), isFalse());
			assertThat(specWith(0, 0, 0, 1, 0).isLessThan(specWith(0, 0, 0, 1, 0)), isFalse());
			assertThat(specWith(0, 0, 0, 0, 1).isLessThan(specWith(0, 0, 0, 0, 1)), isFalse());


			assertThat(specWith(2, 0, 0, 0, 0).isLessThan(specWith(1, 0, 0, 0, 0)), isFalse());
			assertThat(specWith(0, 2, 0, 0, 0).isLessThan(specWith(0, 1, 0, 0, 0)), isFalse());
			assertThat(specWith(0, 0, 2, 0, 0).isLessThan(specWith(0, 0, 1, 0, 0)), isFalse());
			assertThat(specWith(0, 0, 0, 2, 0).isLessThan(specWith(0, 0, 0, 1, 0)), isFalse());
			assertThat(specWith(0, 0, 0, 0, 2).isLessThan(specWith(0, 0, 0, 0, 1)), isFalse());

		}


		[Test]
		public function testIsEqualTo():void {

			var spec1:Specificity = specWith(12, 0, 0, 0, 0);
			var spec2:Specificity = specWith(12, 0, 0, 0, 0);

			assertThat(spec1.isEqualTo(spec2), isTrue());


			spec1 = specWith(12, 1, 0, 0, 0);
			spec2 = specWith(12, 0, 0, 0, 0);

			assertThat(spec1.isEqualTo(spec2), isFalse());
		}



		[Test]
		public function testToNumber():void {

			var spec1:Specificity = new Specificity();
			spec1.manualStyleRule = 12;

			var spec2:Specificity = new Specificity();
			spec2.manualStyleRule = 12;

			assertThat(spec1.toNumber(), equalTo(spec2.toNumber()));



			spec1 = new Specificity();
			spec1.manualStyleRule = 12;
			spec1.idSelector = 1;

			spec2 = new Specificity();
			spec2.manualStyleRule = 12;
			spec2.idSelector = 0;

			assertThat(spec1.toNumber(), greaterThan(spec2.toNumber()));




			spec1 = new Specificity();
			spec1.manualStyleRule = 0;
			spec1.idSelector = 1;

			spec2 = new Specificity();
			spec2.manualStyleRule = 12;
			spec2.idSelector = 0;

			assertThat(spec1.toNumber(), lessThan(spec2.toNumber()));

		}

		
		private function specWith(a:int,  b:int,  c:int, d:int,  e:int):Specificity {
			var spec:Specificity = new Specificity();
			spec.manualStyleRule = a;
			spec.idSelector = b;
			spec.classAndAttributeAndPseudoSelectors = c;
			spec.elementSelectorsAndPseudoElements = d;
			spec.isAElementSelectors = e;

			return spec;
		}
	}
}
