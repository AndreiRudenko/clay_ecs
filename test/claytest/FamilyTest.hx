package claytest;


import utest.Assert;

import clay.Entity;
import clay.World;
import clay.Family;
import clay.core.ComponentManager;
import clay.Components;

import test.claytest.components.MockComponent;
import test.claytest.components.MockComponent2;
import test.claytest.components.MockComponentExtended;

class FamilyTest {


	var world:World;
	var cm:ComponentManager;

	public function new() {}

	public function setup() {
		
		world = new World('world', 16);
		world.families.create('family_a', [MockComponent]);
		world.families.create('family_b', [MockComponent2, MockComponentExtended]);
		world.families.create('family_d', [MockComponent, MockComponent2], [MockComponentExtended]);
		cm = world.components;

	}

	public function test_add_family():Void {

		world.families.create('family_c', [MockComponent, MockComponent2]);
		var fc = world.families.get('family_c');

		Assert.isTrue(fc != null); 

	}

	public function test_get_family():Void {

		var fa = world.families.get('family_a');
		var fb = world.families.get('family_b');

		Assert.isTrue(fa != null); 
		Assert.isTrue(fb != null); 

	}

	public function test_remove_family():Void {

		var fa = world.families.get('family_a');
		var fb = world.families.get('family_b');

		world.families.remove(fa);
		world.families.remove(fb);

		fa = world.families.get('family_a');
		fb = world.families.get('family_b');

		Assert.isTrue(fa == null); 
		Assert.isTrue(fb == null); 

	}

	public function test_get_components_family():Void {

		var mc:Components<MockComponent> = world.components.get_table(MockComponent);
		var mc2:Components<MockComponent2> = world.components.get_table(MockComponent2);
		var mc3:Components<MockComponentExtended> = world.components.get_table(MockComponentExtended);

		var fa = world.families.get('family_a');
		var fb = world.families.get('family_b');

		var e = world.entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		cm.set_many(e, [c1, c2, c3]);

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

	public function test_remove_component_family():Void {

		var mc:Components<MockComponent> = world.components.get_table(MockComponent);
		var mc2:Components<MockComponent2> = world.components.get_table(MockComponent2);
		var mc3:Components<MockComponentExtended> = world.components.get_table(MockComponentExtended);

		var fa = world.families.get('family_a');
		var fb = world.families.get('family_b');

		var e = world.entities.create();
		var e2 = world.entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		cm.set_many(e, [c1, c2, c3]);

		Assert.isTrue(fa.has(e)); 
		Assert.isTrue(fb.has(e)); 

		mc.remove(e);

		Assert.isFalse(fa.has(e)); 
		Assert.isTrue(fb.has(e)); 

	}

	public function test_exclude_components_family():Void {

		var mc:Components<MockComponent> = world.components.get_table(MockComponent);
		var mc2:Components<MockComponent2> = world.components.get_table(MockComponent2);
		var mc3:Components<MockComponentExtended> = world.components.get_table(MockComponentExtended);

		var fd = world.families.get('family_d');

		var e = world.entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		cm.set_many(e, [c1, c2, c3]);

		var e2 = world.entities.create();

		var c1 = new MockComponent(456);
		var c2 = new MockComponent2();

		cm.set_many(e2, [c1, c2]);

		trace(fd);

		Assert.isTrue(fd.has(e2)); 
		Assert.isFalse(fd.has(e)); 

	}


}

