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

	public function new() {}

	public function setup() {
		
		world = new World({
			name : 'world',
			processors : [],
			families : [
				new Family('family_a', [MockComponent]),
				new Family('family_b', [MockComponent2, MockComponentExtended])
			],
			capacity : 16
		});

	}

	public function test_add_family():Void {

		world.families.add(new Family('family_c', [MockComponent, MockComponent2]));
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

		world.components.set(e, c1);
		world.components.set(e, c2);
		world.components.set(e, c3);

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

		world.components.set(e, c1);
		world.components.set(e, c2);
		world.components.set(e, c3);

		Assert.isTrue(fa.has(e)); 
		Assert.isTrue(fb.has(e)); 

		mc.remove(e);

		Assert.isFalse(fa.has(e)); 
		Assert.isTrue(fb.has(e)); 

	}


}

