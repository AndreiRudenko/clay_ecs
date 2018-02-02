package claytest;


import utest.Assert;

import clay.Entity;
import clay.World;
import clay.Components;
import clay.core.ComponentManager;

import test.claytest.components.MockComponent;
import test.claytest.components.MockComponent2;
import test.claytest.components.MockComponentExtended;


class ComponentTest {


	var world:World;
	var cm:ComponentManager;

	public function new() {}

	public function setup() {
		
		world = new World('world', 16384);
		cm = world.components;

	}

	public function test_set_component():Void {
		
		var e = world.entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		cm.set_many(e, [c1, c2, c3]);

		Assert.isTrue(cm.has(e, MockComponent)); 
		Assert.isTrue(cm.has(e, MockComponent2)); 
		Assert.isTrue(cm.has(e, MockComponentExtended)); 

	}

	public function test_remove_components():Void {

		var e = world.entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		cm.set_many(e, [c1, c2, c3]);

		cm.remove(e, MockComponent);
		cm.remove(e, MockComponent2);
		cm.remove(e, MockComponentExtended);

		Assert.isFalse(cm.has(e, MockComponent)); 
		Assert.isFalse(cm.has(e, MockComponent2)); 
		Assert.isFalse(cm.has(e, MockComponentExtended)); 

	}

	public function test_remove_some_components():Void {

		var e = world.entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		cm.set_many(e, [c1, c2, c3]);

		// cm.remove(e, MockComponent);
		cm.remove(e, MockComponent2);
		// cm.remove(e, MockComponentExtended);

		Assert.isTrue(cm.has(e, MockComponent)); 
		Assert.isFalse(cm.has(e, MockComponent2)); 
		Assert.isTrue(cm.has(e, MockComponentExtended)); 

	}

	public function test_remove_all_components():Void {

		var e = world.entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		cm.set_many(e, [c1, c2, c3]);

		cm.remove_all(e);

		Assert.isFalse(cm.has(e, MockComponent)); 
		Assert.isFalse(cm.has(e, MockComponent2)); 
		Assert.isFalse(cm.has(e, MockComponentExtended)); 

	}

	public function test_get_component():Void {

		var e = world.entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		cm.set_many(e, [c1, c2, c3]);

		var _c1 = cm.get(e, MockComponent);
		var _c2 = cm.get(e, MockComponent2);
		var _c3 = cm.get(e, MockComponentExtended);

		Assert.isTrue(c1 == _c1); 
		Assert.isTrue(c2 == _c2); 
		Assert.isTrue(c3 == _c3); 

	}

	public function test_get_component2():Void {

		var mc:Components<MockComponent> = cm.get_table(MockComponent);
		var mc2:Components<MockComponent2> = cm.get_table(MockComponent2);
		var mc3:Components<MockComponentExtended> = cm.get_table(MockComponentExtended);

		var e = world.entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		cm.set_many(e, [c1, c2, c3]);

		var _c1 = mc.get(e);
		var _c2 = mc2.get(e);
		var _c3 = mc3.get(e);

		Assert.isTrue(c1 == _c1); 
		Assert.isTrue(c1.value == 123); 
		Assert.isTrue(c2 == _c2); 
		Assert.isTrue(c3 == _c3); 

	}

	public function test_copy_component():Void {

		var e1 = world.entities.create();
		var e2 = world.entities.create();

		var c1 = new MockComponent(123);

		cm.set(e1, c1);
		cm.copy(e1, e2, MockComponent);

		var _c1 = cm.get(e2, MockComponent);

		Assert.isTrue(c1 == _c1); 

	}


}

