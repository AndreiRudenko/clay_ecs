package clay.core;



import clay.ds.Int32RingBuffer;
import clay.ds.BitVector;
import clay.containers.EntityVector;

import clay.Entity;
import clay.Family;
import clay.types.ComponentType;
import clay.core.ComponentManager;

@:access(clay.Family)
@:access(clay.core.ComponentManager)
class FamilyManager {


	var components:ComponentManager;
	var families:Array<Family>;


	public function new(_components:ComponentManager) {
		
		components = _components;
		components._entity_changed = check_entity;

		families = [];

	}

		/** create family */
	public function create(_name:String, ?_include:Array<Class<Dynamic>>, ?_exclude:Array<Class<Dynamic>>){

		var _family = new Family(this, _name, _include, _exclude);
		handle_duplicate_warning(_family.name);
		families.push(_family);

	}

		/** remove family */
	public function remove(_family:Family) {

		families.remove(_family);
		
	}

		/** get family */
	public function get(_name:String):Family {

		for (f in families) {
			if(f.name == _name) {
				return f;
			}
		}

		return null;
		
	}
		/** check entity if it match families */
	public function check_entity(e:Entity) {
		
		for (f in families) {
			f.check(e);
		}

	}

		/** remove all families */
	public function clear() {

		families.splice(0, families.length);

	}

	inline function handle_duplicate_warning(_name:String) {

		var _f:Family = get(_name);
		if(_f != null) {
			trace('adding a second family named: "${_name}"! This will replace the existing one, possibly leaving the previous one in limbo.');
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

		return families.iterator();

	}


}