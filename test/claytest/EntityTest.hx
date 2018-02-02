package claytest;


import utest.Assert;

import clay.Entity;
import clay.core.EntityManager;


class EntityTest {


	var entities:EntityManager;

	public function new():Void {}

	public function setup() {

		entities = new EntityManager(32);

	}

	public function teardown() {
		
		entities.destroy_manager();
		entities = null;

	}

	public function test_entity_create():Void {

		var e = entities.create();

		Assert.isTrue(entities.has(e)); 
		Assert.isTrue(entities.is_active(e)); 

	}

	public function test_entity_create_inactive():Void {

		var e = entities.create(false);

		Assert.isTrue(entities.has(e)); 
		Assert.isFalse(entities.is_active(e)); 

	}

	public function test_entity_destroy():Void {

		var e = entities.create();

		entities.destroy(e);

		Assert.isFalse(entities.has(e)); 

	}

	public function test_entity_activate_deactivate():Void {

		var e = entities.create();

		Assert.isTrue(entities.is_active(e)); 

		entities.deactivate(e);
		Assert.isFalse(entities.is_active(e)); 

		entities.activate(e);
		Assert.isTrue(entities.is_active(e)); 

	}

}

