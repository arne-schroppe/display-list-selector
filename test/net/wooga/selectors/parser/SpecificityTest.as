package net.wooga.selectors.parser {

	import net.wooga.selectors.specificity.SpecificityComparison;

	import org.hamcrest.assertThat;
	import org.hamcrest.core.not;
	import org.hamcrest.number.greaterThan;
	import org.hamcrest.number.lessThan;
	import org.hamcrest.object.equalTo;

	public class SpecificityTest {


		[Test]
		public function testIsGreaterThan():void {

			var smallerSpec:SpecificityImpl = specWith(1, 10, 0, 0, 0);

			var higherSpec:SpecificityImpl = specWith(2, 6, 0, 0, 0);

			assertThat(higherSpec.compare(smallerSpec), equalTo(SpecificityComparison.GREATER_THAN));




			smallerSpec = specWith(0, 10, 0, 0, 0);
			higherSpec = specWith(1, 0, 0, 0, 0);

			assertThat(higherSpec.compare(smallerSpec), equalTo(SpecificityComparison.GREATER_THAN));



			smallerSpec = specWith(0, 0, 5, 0, 0);
			higherSpec = specWith(0, 1, 0, 0, 0);

			assertThat(higherSpec.compare(smallerSpec), equalTo(SpecificityComparison.GREATER_THAN));



			assertThat(specWith(2, 0, 0, 0, 0).compare(specWith(1, 0, 0, 0, 0)), equalTo(SpecificityComparison.GREATER_THAN));
			assertThat(specWith(0, 2, 0, 0, 0).compare(specWith(0, 1, 0, 0, 0)), equalTo(SpecificityComparison.GREATER_THAN));
			assertThat(specWith(0, 0, 2, 0, 0).compare(specWith(0, 0, 1, 0, 0)), equalTo(SpecificityComparison.GREATER_THAN));
			assertThat(specWith(0, 0, 0, 2, 0).compare(specWith(0, 0, 0, 1, 0)), equalTo(SpecificityComparison.GREATER_THAN));
			assertThat(specWith(0, 0, 0, 0, 2).compare(specWith(0, 0, 0, 0, 1)), equalTo(SpecificityComparison.GREATER_THAN));



			assertThat(specWith(1, 0, 0, 0, 0).compare(specWith(1, 0, 0, 0, 0)), not(equalTo(SpecificityComparison.GREATER_THAN)));
			assertThat(specWith(0, 1, 0, 0, 0).compare(specWith(0, 1, 0, 0, 0)), not(equalTo(SpecificityComparison.GREATER_THAN)));
			assertThat(specWith(0, 0, 1, 0, 0).compare(specWith(0, 0, 1, 0, 0)), not(equalTo(SpecificityComparison.GREATER_THAN)));
			assertThat(specWith(0, 0, 0, 1, 0).compare(specWith(0, 0, 0, 1, 0)), not(equalTo(SpecificityComparison.GREATER_THAN)));
			assertThat(specWith(0, 0, 0, 0, 1).compare(specWith(0, 0, 0, 0, 1)), not(equalTo(SpecificityComparison.GREATER_THAN)));


			assertThat(specWith(2, 0, 0, 0, 0).compare(specWith(3, 0, 0, 0, 0)), not(equalTo(SpecificityComparison.GREATER_THAN)));
			assertThat(specWith(0, 2, 0, 0, 0).compare(specWith(0, 3, 0, 0, 0)), not(equalTo(SpecificityComparison.GREATER_THAN)));
			assertThat(specWith(0, 0, 2, 0, 0).compare(specWith(0, 0, 3, 0, 0)), not(equalTo(SpecificityComparison.GREATER_THAN)));
			assertThat(specWith(0, 0, 0, 2, 0).compare(specWith(0, 0, 0, 3, 0)), not(equalTo(SpecificityComparison.GREATER_THAN)));
			assertThat(specWith(0, 0, 0, 0, 2).compare(specWith(0, 0, 0, 0, 3)), not(equalTo(SpecificityComparison.GREATER_THAN)));

		}


		[Test]
		public function testIsLessThan():void {

			var smallerSpec:SpecificityImpl = specWith(1, 10, 0, 0, 0);

			var higherSpec:SpecificityImpl = specWith(2, 6, 0, 0, 0);

			assertThat(smallerSpec.compare(higherSpec), equalTo(SpecificityComparison.LESS_THAN));

			smallerSpec = specWith(0, 10, 0, 0, 0);
			higherSpec = specWith(1, 0, 0, 0, 0);

			assertThat(smallerSpec.compare(higherSpec), equalTo(SpecificityComparison.LESS_THAN));


			smallerSpec = specWith(0, 0, 5, 0, 0);

			higherSpec = specWith(0, 1, 0, 0, 0);

			assertThat(smallerSpec.compare(higherSpec), equalTo(SpecificityComparison.LESS_THAN));




			assertThat(specWith(1, 0, 0, 0, 0).compare(specWith(2, 0, 0, 0, 0)), equalTo(SpecificityComparison.LESS_THAN));
			assertThat(specWith(0, 1, 0, 0, 0).compare(specWith(0, 2, 0, 0, 0)), equalTo(SpecificityComparison.LESS_THAN));
			assertThat(specWith(0, 0, 1, 0, 0).compare(specWith(0, 0, 2, 0, 0)), equalTo(SpecificityComparison.LESS_THAN));
			assertThat(specWith(0, 0, 0, 1, 0).compare(specWith(0, 0, 0, 2, 0)), equalTo(SpecificityComparison.LESS_THAN));
			assertThat(specWith(0, 0, 0, 0, 1).compare(specWith(0, 0, 0, 0, 2)), equalTo(SpecificityComparison.LESS_THAN));

			

			assertThat(specWith(1, 0, 0, 0, 0).compare(specWith(1, 0, 0, 0, 0)), not(equalTo(SpecificityComparison.LESS_THAN)));
			assertThat(specWith(0, 1, 0, 0, 0).compare(specWith(0, 1, 0, 0, 0)), not(equalTo(SpecificityComparison.LESS_THAN)));
			assertThat(specWith(0, 0, 1, 0, 0).compare(specWith(0, 0, 1, 0, 0)), not(equalTo(SpecificityComparison.LESS_THAN)));
			assertThat(specWith(0, 0, 0, 1, 0).compare(specWith(0, 0, 0, 1, 0)), not(equalTo(SpecificityComparison.LESS_THAN)));
			assertThat(specWith(0, 0, 0, 0, 1).compare(specWith(0, 0, 0, 0, 1)), not(equalTo(SpecificityComparison.LESS_THAN)));


			assertThat(specWith(2, 0, 0, 0, 0).compare(specWith(1, 0, 0, 0, 0)), not(equalTo(SpecificityComparison.LESS_THAN)));
			assertThat(specWith(0, 2, 0, 0, 0).compare(specWith(0, 1, 0, 0, 0)), not(equalTo(SpecificityComparison.LESS_THAN)));
			assertThat(specWith(0, 0, 2, 0, 0).compare(specWith(0, 0, 1, 0, 0)), not(equalTo(SpecificityComparison.LESS_THAN)));
			assertThat(specWith(0, 0, 0, 2, 0).compare(specWith(0, 0, 0, 1, 0)), not(equalTo(SpecificityComparison.LESS_THAN)));
			assertThat(specWith(0, 0, 0, 0, 2).compare(specWith(0, 0, 0, 0, 1)), not(equalTo(SpecificityComparison.LESS_THAN)));

		}


		[Test]
		public function testIsEqualTo():void {

			var spec1:SpecificityImpl = specWith(12, 0, 0, 0, 0);
			var spec2:SpecificityImpl = specWith(12, 0, 0, 0, 0);

			assertThat(spec1.compare(spec2), equalTo(SpecificityComparison.EQUAL));


			spec1 = specWith(12, 1, 0, 0, 0);
			spec2 = specWith(12, 0, 0, 0, 0);

			assertThat(spec1.compare(spec2), not(equalTo(SpecificityComparison.EQUAL)));
		}



//		[Test]
//		public function testToNumber():void {
//
//			var spec1:SpecificityImpl = new SpecificityImpl();
//			spec1.manualStyleRule = 12;
//
//			var spec2:SpecificityImpl = new SpecificityImpl();
//			spec2.manualStyleRule = 12;
//
//			assertThat(spec1.asNumber, equalTo(spec2.asNumber));
//
//
//
//			spec1 = new SpecificityImpl();
//			spec1.manualStyleRule = 12;
//			spec1.idSelector = 1;
//
//			spec2 = new SpecificityImpl();
//			spec2.manualStyleRule = 12;
//			spec2.idSelector = 0;
//
//			assertThat(spec1.asNumber, greaterThan(spec2.asNumber));
//
//
//
//
//			spec1 = new SpecificityImpl();
//			spec1.manualStyleRule = 0;
//			spec1.idSelector = 1;
//
//			spec2 = new SpecificityImpl();
//			spec2.manualStyleRule = 12;
//			spec2.idSelector = 0;
//
//			assertThat(spec1.asNumber, lessThan(spec2.asNumber));
//
//		}

		
		private function specWith(a:int,  b:int,  c:int, d:int,  e:int):SpecificityImpl {
			var spec:SpecificityImpl = new SpecificityImpl();
			spec.manualStyleRule = a;
			spec.idSelector = b;
			spec.classAndAttributeAndPseudoSelectors = c;
			spec.elementSelectorsAndPseudoElements = d;
			spec.isAPseudoClassSelectors = e;

			return spec;
		}
	}
}
