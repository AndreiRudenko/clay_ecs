package claytest;


import utest.Assert;

import clay.Entity;
import clay.Family;
import clay.core.EntityManager;
import clay.core.ComponentManager;
import clay.core.FamilyManager;
import clay.Components;

import test.claytest.components.MockComponent;
import test.claytest.components.MockComponent2;
import test.claytest.components.MockComponentExtended;

class FamilyTest {


	var entities:EntityManager;
	var components:ComponentManager;
	var families:FamilyManager;

	public function new() {}

	public function setup() {
		
		entities = new EntityManager(32);
		components = new ComponentManager(entities);
		families = new FamilyManager(components);

		families.create('family_a', [MockComponent]);
		families.create('family_b', [MockComponent2, MockComponentExtended]);
		families.create('family_d', [MockComponent, MockComponent2], [MockComponentExtended]);

	}

	public function test_add_family():Void {

		families.create('family_c', [MockComponent, MockComponent2]);
		var fc = families.get('family_c');

		Assert.isTrue(fc != null); 

	}

	public function test_get_family():Void {

		var fa = families.get('family_a');
		var fb = families.get('family_b');

		Assert.isTrue(fa != null); 
		Assert.isTrue(fb != null); 

	}

	public function test_remove_family():Void {

		var fa = families.get('family_a');
		var fb = families.get('family_b');

		families.remove(fa);
		families.remove(fb);

		fa = families.get('family_a');
		fb = families.get('family_b');

		Assert.isTrue(fa == null); 
		Assert.isTrue(fb == null); 

	}

	public function test_get_components_family():Void {

		var mc:Components<MockComponent> = components.get_table(MockComponent);
		var mc2:Components<MockComponent2> = components.get_table(MockComponent2);
		var mc3:Components<MockComponentExtended> = components.get_table(MockComponentExtended);

		var fa = families.get('family_a');
		var fb = families.get('family_b');

		var e = entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		components.set_many(e, [c1, c2, c3]);

		for (ent in fa) {
			var _c1 = mc.get(ent);
			Assert.isTrue(c1 == _c1); 
			Assert.isTrue(_c1.value == 123); 
		}

		for (ent in fb) {
			var _c2 = mc2.get(ent);
			var _c3 = mc3.get(ent);
			Assert.isTrue(c2 == _c2); 
			Assert.isTrue(c3 == _c3); 
		}

	}

	public function test_has_component_family():Void {

		var mc:Components<MockComponent> = components.get_table(MockComponent);
		var mc2:Components<MockComponent2> = components.get_table(MockComponent2);
		var mc3:Components<MockComponentExtended> = components.get_table(MockComponentExtended);

		var fa = families.get('family_a');
		var fb = families.get('family_b');

		var e = entities.create();
		var e2 = entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		components.set_many(e, [c1, c2, c3]);

		Assert.isTrue(fa.has(e)); 
		Assert.isTrue(fb.has(e)); 

	}

	public function test_remove_component_family():Void {

		var mc:Components<MockComponent> = components.get_table(MockComponent);
		var mc2:Components<MockComponent2> = components.get_table(MockComponent2);
		var mc3:Components<MockComponentExtended> = components.get_table(MockComponentExtended);

		var fa = families.get('family_a');
		var fb = families.get('family_b');

		var e = entities.create();
		var e2 = entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		components.set_many(e, [c1, c2, c3]);

		Assert.isTrue(fa.has(e)); 
		Assert.isTrue(fb.has(e)); 

		mc.remove(e);

		Assert.isFalse(fa.has(e)); 
		Assert.isTrue(fb.has(e)); 

	}

	public function test_exclude_components_family():Void {

		var mc:Components<MockComponent> = components.get_table(MockComponent);
		var mc2:Components<MockComponent2> = components.get_table(MockComponent2);
		var mc3:Components<MockComponentExtended> = components.get_table(MockComponentExtended);

		var fd = families.get('family_d');

		var e = entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		components.set_many(e, [c1, c2, c3]);

		var e2 = entities.create();

		var c1 = new MockComponent(456);
		var c2 = new MockComponent2();

		components.set_many(e2, [c1, c2]);

		Assert.isTrue(fd.has(e2)); 
		Assert.isFalse(fd.has(e)); 

	}


}

