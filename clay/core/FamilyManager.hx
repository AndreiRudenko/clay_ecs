package clay.core;



import clay.ds.Int32RingBuffer;
import clay.ds.BitVector;
import clay.containers.EntityVector;
import clay.utils.Log.*;

import clay.Entity;
import clay.Family;
import clay.types.ComponentType;
import clay.core.ComponentManager;

@:access(clay.Family)
@:access(clay.core.ComponentManager)
class FamilyManager {


	var components:ComponentManager;
	var families:Map<String, Family>; // array?


	public function new(_components:ComponentManager) {
		
		components = _components;
		components._entity_changed = check;

		families = new Map();

	}

	public function create(_name:String, ?_include:Array<Class<Dynamic>>, ?_exclude:Array<Class<Dynamic>>){

		var _family = new Family(this, _name, _include, _exclude);

		handle_duplicate_warning(_family.name);

		families.set(_family.name, _family);

	}

	public function remove(_family:Family) {

		families.remove(_family.name);
		
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

	}

	@:noCompletion public function destroy_manager() {

		components = null;
		families = null;

	}

	function check(e:Entity) {
		
		for (f in families) {
			f.check(e);
		}

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