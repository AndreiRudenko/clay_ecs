package clay.core;



import clay.ds.Int32RingBuffer;
import clay.ds.BitVector;
import clay.containers.EntityVector;
import clay.utils.Log.*;

import clay.Entity;
import clay.Family;
import clay.World;


class FamilyManager {


	var world:World;
	var families:Map<String, Family>; // array?


	public function new(_world:World, ?_families:Array<Family>) {
		
		world = _world;

		families = new Map();

		if(_families != null) {
			for (f in _families) {
				add(f);
			}
		}

	}

	@:noCompletion public function init() {

		for (f in families) {
			f.init(world);
		}
		
	}

	public function add(_family:Family) {

		handle_duplicate_warning(_family.name);

		families.set(_family.name, _family);

		if(world.inited) {
			_family.init(world);
		}
		world.changed();
		
	}

	public function remove(_family:Family) {

		families.remove(_family.name);

		world.changed();
		
	}

	public inline function get(_name:String):Family {

		return families.get(_name);
		
	}

		/** remove all families */
	public function clear() {

		_debug('remove all families');

		for (f in families) {
			families.remove(f.name);
		}
		
		world.changed();

	}

	@:noCompletion public function destroy_manager() {

		world = null;
		families = null;

	}
	
	inline function handle_duplicate_warning(_name:String) {

		var _f:Family = families.get(_name);
		if(_f != null) {
			log('adding a second family named: "${_name}"! This will replace the existing one, possibly leaving the previous one in limbo.');
			remove(_f);
		}

	}

	inline function toString() {

		var _list = []; 

		for (f in families) {
			_list.push(f.toString());
		}

		return 'families: [${_list.join(", ")}]';

	}

	@:noCompletion public inline function iterator():Iterator<Family> {
			// array iteration is faster
		return families.iterator();

	}


}