package claytest;


import utest.Assert;

import clay.Entity;
import clay.World;


class EntityTest {


	var world:World;

	public function new():Void {}

	public function setup() {

		world = new World('world', 32);

	}

	public function teardown() {
		
		world.destroy();
		world = null;

	}

	public function test_entity_create():Void {

		var e = world.entities.create();

		Assert.isTrue(world.entities.has(e)); 
		Assert.isTrue(world.entities.is_active(e)); 

	}

	public function test_entity_create_inactive():Void {

		var e = world.entities.create(null, false);

		Assert.isTrue(world.entities.has(e)); 
		Assert.isFalse(world.entities.is_active(e)); 

	}

	public function test_entity_destroy():Void {

		var e = world.entities.create();

		world.entities.destroy(e);

		Assert.isFalse(world.entities.has(e)); 

	}

	public function test_entity_activate_deactivate():Void {

		var e = world.entities.create();

		Assert.isTrue(world.entities.is_active(e)); 

		world.entities.deactivate(e);
		Assert.isFalse(world.entities.is_active(e)); 

		world.entities.activate(e);
		Assert.isTrue(world.entities.is_active(e)); 

	}

}

