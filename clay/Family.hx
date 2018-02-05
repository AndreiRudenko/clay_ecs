package clay;


import clay.Entity;
import clay.core.ComponentManager;
import clay.core.FamilyManager;
import clay.containers.EntityVector;
import clay.types.ComponentType;
import clay.core.Signal;
import clay.ds.BitFlag;


@:final @:unreflective @:dce
@:access(clay.core.FamilyManager)
@:access(clay.core.ComponentManager)
class Family {
	

	public var name         (default, null):String;
	public var inited       (default, null):Bool = false;
	public var length       (get, never):Int;

	public var onadded  	(default, null):Signal<Entity->Void>;
	public var onremoved	(default, null):Signal<Entity->Void>;

	var _entities:EntityVector;
	var _components:ComponentManager;
	var _include_flags:BitFlag;
	var _exclude_flags:BitFlag;
	

	public function new(manager:FamilyManager, _name:String, ?_include:Array<Class<Dynamic>>, ?_exclude:Array<Class<Dynamic>>) {

		name = _name;

		_components = manager.components;
		_entities = new EntityVector(_components.entities.capacity);

		onadded = new Signal();
		onremoved = new Signal();

		_include_flags = new BitFlag();
		_exclude_flags = new BitFlag();
		_exclude_flags.flip();

		if(_include != null) {
			include(_include);
		}

		if(_exclude != null) {
			exclude(_exclude);
		}

	}

	public function include(_comps:Array<Class<Dynamic>>):Family {

		var ct:ComponentType;
		for (c in _comps) {
			ct = _components.get_type(c);
			_include_flags.set_true(ct.id + 1);
		}

        return this;

	}

	public function exclude(_comps:Array<Class<Dynamic>>):Family {

		var ct:ComponentType;
		for (c in _comps) {
			ct = _components.get_type(c);
			_exclude_flags.set_false(ct.id + 1);
		}

        return this;

	}

	public function check(e:Entity) {

		if(!_has(e)) {
			if(_match_entity(e)) {
				_add(e);
			}
		} else if(!_match_entity(e)) {
			_remove(e);
		}
		
	}

	public function has(e:Entity):Bool {
		
		return _has(e);

	}

	inline function _add(e:Entity) {

		_entities.add_unsafe(e);

		onadded.emit(e);

	}

	inline function _remove(e:Entity) {

		onremoved.emit(e);
		
		_entities.remove_unsafe(e);

	}

	inline function _has(e:Entity):Bool {

		return _entities.has(e);
		
	}

	@:access(clay.core.ComponentManager)
	inline function _match_entity(e:Entity):Bool {

		var _flags = _components.flags[e.id];
		return _flags.contains(_include_flags) && _exclude_flags.contains(_flags);

	}

	inline function get_length():Int {

		return _entities.length;
		
	}

	@:noCompletion public function toString() {

		var _list = []; 

		for (i in this.iterator()) {
			_list.push(i.id);
		}

		return '$name: [${_list.join(", ")}]';

	}

	@:noCompletion public inline function iterator():EntityVectorIterator {

		return _entities.iterator();

	}


}
