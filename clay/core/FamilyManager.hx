package clay.core;



import clay.ds.Int32RingBuffer;
import clay.ds.BitVector;
import clay.containers.EntityVector;
import clay.utils.Log.*;

import clay.Entity;
import clay.Family;
import clay.World;
import clay.types.ComponentType;

@:access(clay.Family)
class FamilyManager {


	var world:World;
	var families:Map<String, Family>; // array?


	public function new(_world:World) {
		
		world = _world;

		families = new Map();

	}

	public function create(_name:String, ?_include:Array<Class<Dynamic>>, ?_exclude:Array<Class<Dynamic>>){

		var _family = new Family(world, _name, _include, _exclude);

		handle_duplicate_warning(_family.name);

		families.set(_family.name, _family);

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

	inline function component_added(e:Entity, ct:ComponentType) {
		
		for (f in families) {
			f.component_added(e, ct);
		}
		world.changed();

	}

	inline function component_removed(e:Entity, ct:ComponentType) {
		
		for (f in families) {
			f.component_removed(e, ct);
		}
		world.changed();

	}

	inline function check(e:Entity) {
		
		for (f in families) {
			f.check(e);
		}
		world.changed();

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