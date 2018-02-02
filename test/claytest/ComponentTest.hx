package claytest;


import utest.Assert;

import clay.Entity;
import clay.Components;
import clay.core.EntityManager;
import clay.core.ComponentManager;

import test.claytest.components.MockComponent;
import test.claytest.components.MockComponent2;
import test.claytest.components.MockComponentExtended;


class ComponentTest {


	var entities:EntityManager;
	var components:ComponentManager;

	public function new() {}

	public function setup() {
		
		entities = new EntityManager(32);
		components = new ComponentManager(entities);

	}

	public function test_set_component():Void {
		
		var e = entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		components.set_many(e, [c1, c2, c3]);

		Assert.isTrue(components.has(e, MockComponent)); 
		Assert.isTrue(components.has(e, MockComponent2)); 
		Assert.isTrue(components.has(e, MockComponentExtended)); 

	}

	public function test_remove_components():Void {

		var e = entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		components.set_many(e, [c1, c2, c3]);

		components.remove(e, MockComponent);
		components.remove(e, MockComponent2);
		components.remove(e, MockComponentExtended);

		Assert.isFalse(components.has(e, MockComponent)); 
		Assert.isFalse(components.has(e, MockComponent2)); 
		Assert.isFalse(components.has(e, MockComponentExtended)); 

	}

	public function test_remove_some_components():Void {

		var e = entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		components.set_many(e, [c1, c2, c3]);

		// components.remove(e, MockComponent);
		components.remove(e, MockComponent2);
		// components.remove(e, MockComponentExtended);

		Assert.isTrue(components.has(e, MockComponent)); 
		Assert.isFalse(components.has(e, MockComponent2)); 
		Assert.isTrue(components.has(e, MockComponentExtended)); 

	}

	public function test_remove_all_components():Void {

		var e = entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		components.set_many(e, [c1, c2, c3]);

		components.remove_all(e);

		Assert.isFalse(components.has(e, MockComponent)); 
		Assert.isFalse(components.has(e, MockComponent2)); 
		Assert.isFalse(components.has(e, MockComponentExtended)); 

	}

	public function test_get_component():Void {

		var e = entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		components.set_many(e, [c1, c2, c3]);

		var _c1 = components.get(e, MockComponent);
		var _c2 = components.get(e, MockComponent2);
		var _c3 = components.get(e, MockComponentExtended);

		Assert.isTrue(c1 == _c1); 
		Assert.isTrue(c2 == _c2); 
		Assert.isTrue(c3 == _c3); 

	}

	public function test_get_component2():Void {

		var mc:Components<MockComponent> = components.get_table(MockComponent);
		var mc2:Components<MockComponent2> = components.get_table(MockComponent2);
		var mc3:Components<MockComponentExtended> = components.get_table(MockComponentExtended);

		var e = entities.create();

		var c1 = new MockComponent(123);
		var c2 = new MockComponent2();
		var c3 = new MockComponentExtended();

		components.set_many(e, [c1, c2, c3]);

		var _c1 = mc.get(e);
		var _c2 = mc2.get(e);
		var _c3 = mc3.get(e);

		Assert.isTrue(c1 == _c1); 
		Assert.isTrue(c1.value == 123); 
		Assert.isTrue(c2 == _c2); 
		Assert.isTrue(c3 == _c3); 

	}

	public function test_copy_component():Void {

		var e1 = entities.create();
		var e2 = entities.create();

		var c1 = new MockComponent(123);

		components.set(e1, c1);
		components.copy(e1, e2, MockComponent);

		var _c1 = components.get(e2, MockComponent);

		Assert.isTrue(c1 == _c1); 

	}


}

