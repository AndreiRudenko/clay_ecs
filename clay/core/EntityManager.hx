package clay.core;



import clay.ds.Int32RingBuffer;
import clay.ds.BitVector;
import clay.containers.EntityVector;
import clay.utils.Log.*;

import clay.Entity;
import clay.World;

class EntityManager {


	public var capacity (default, null):Int; // 16384, 65536
	public var used (default, null): Int;
	public var available(get, never):Int;

	var world:World;

	var _id_pool : Int32RingBuffer;
	
	var _alive_mask : BitVector;
	var _active_mask : BitVector;
	var _entities : EntityVector;


	public function new(_world:World, _capacity:Int) {

		_debug('create new EntityManager');

		world = _world;

		capacity = _capacity;
		used = 0;

		_id_pool = new Int32RingBuffer(capacity);

		_entities = new EntityVector(capacity);

		_alive_mask = new BitVector(capacity);
		_active_mask = new BitVector(capacity);

	}

	@:access(clay.containers.EntityVector)
	public function create(?_components:Array<Dynamic>, ?_active:Bool) : Entity {

		var id:Int = pop_entity_id();
		var e:Entity = new Entity(id); 

		_alive_mask.enable(id);

		if(_active != false) {
			_active_mask.enable(id);
		}

		_entities._add(id);

		if(_components != null) {
			world.components.set_many(e, _components);
		}
		
		world.changed();

		return e;

	}

	@:access(clay.containers.EntityVector)
	public function destroy(e:Entity) {

		var id:Int = e.id;

		assert(has(e), 'entity $id destroying repeatedly ');

		// remove components here
		world.components.remove_all(e);

		_alive_mask.disable(id);
		_active_mask.disable(id);

		_entities._remove(id);

		push_entity_id(id);

		world.changed();
		
	}

	public inline function has(e:Entity):Bool {

		return _alive_mask.get(e.id);

	}

	// check if it has id first
	public inline function get(id:Int):Entity {

		assert(_alive_mask.get(id), 'get / entity ${id} is not found');

		return new Entity(id);

	}

	public inline function is_active(e:Entity):Bool {

		assert(has(e), 'is_active / entity ${e.id} is not found');

		return _active_mask.get(e.id);
		
	}

	public inline function activate(e:Entity) {

		assert(has(e), 'activate / entity ${e.id} is not found');

		_active_mask.enable(e.id);

		world.changed();

	}

	public inline function deactivate(e:Entity) {

		assert(has(e), 'deactivate / entity ${e.id} is not found');

		_active_mask.disable(e.id);

		world.changed();

	}

		/** destroy EntityManager */
	@:noCompletion public function destroy_manager() {

		_debug('destroy EntityManager');
		
		clear();

		_entities = null;
		_alive_mask = null;
		_active_mask = null;
		_id_pool = null;
		
	}

		/** remove and destroy all _entities */
	public function clear() {

		_debug('destroy all entities');

		for (e in _entities) {
			destroy(e);
		}

		_alive_mask.clear();
		_active_mask.clear();
		_id_pool.clear();
		
		world.changed();

	}


	function get_available():Int {

		return capacity - used;

	}

	function pop_entity_id():Int {

		if(used >= capacity) {
			throw 'Out of entities, max allowed ${capacity}';
		}

		++used;
		return _id_pool.pop();

	}

	function push_entity_id(_id:Int) {

		--used;
		_id_pool.push(_id);

	}

	inline function toString() {

		var _list = []; 

		for (e in _entities) {
			_list.push(e);
		}

		return 'entities: [${_list.join(", ")}]';

	}

	@:noCompletion public inline function iterator():EntityVectorIterator {

		return _entities.iterator();

	}


}