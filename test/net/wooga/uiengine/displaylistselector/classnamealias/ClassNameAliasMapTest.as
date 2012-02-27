package net.wooga.uiengine.displaylistselector.classnamealias {
	import flash.utils.getQualifiedClassName;

	import net.arneschroppe.displaytreebuilder.DisplayTree;
	import net.wooga.fixtures.ContextViewBasedTest;
	import net.wooga.fixtures.TestSpriteA;
	import net.wooga.fixtures.TestSpriteB;
	import net.wooga.fixtures.TestSpriteC;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class ClassNameAliasMapTest extends ContextViewBasedTest {

	private var _classNameInferenceStrategy:IClassNameInferenceStrategy;

		private var _aliasMap:ClassNameAliasMap;

		[Before]
		override public function setUp():void {
			super.setUp();

			_classNameInferenceStrategy = new AliasIsUnqualifiedClassNameInferenceStrategy();
			_aliasMap = new ClassNameAliasMap(contextView, _classNameInferenceStrategy);
		}


		[Test]
		public function should_store_class_alias():void {

			var alias:String = "TestAlias";
			var className:String = "com.wooga.foo.bar.baz.Quux";

			_aliasMap.setAlias(alias, className);

			assertThat(_aliasMap.classNameFor(alias), equalTo(className));
		}


		[Test]
		public function should_infer_class_name_for_alias():void {

			var treeBuilder:DisplayTree = new DisplayTree();
			treeBuilder.hasA(contextView).containing.
					a(TestSpriteA).
					a(TestSpriteB).containing.
						a(TestSpriteC).
					end.
				end.finish();

			var alias:String = "TestSpriteC";
			var className:String = _aliasMap.classNameFor(alias);

			assertThat(className, equalTo(getQualifiedClassName(TestSpriteC).replace("::", ".")));
		}
	}
}
