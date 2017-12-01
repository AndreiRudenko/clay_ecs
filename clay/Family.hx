package clay;


import clay.World;
import clay.Entity;
import clay.core.ComponentManager;
import clay.containers.EntityVector;
import clay.types.ComponentType;
import clay.signals.Signal;


@:final @:unreflective @:dce
class Family {

	public var name(default, null):String;
	public var inited(default, null):Bool = false;

	public var onadded:Signal<Entity->Void>;
	public var onremoved:Signal<Entity->Void>;

	var _world:World;
	var _entities:EntityVector;
	var _components:ComponentManager;
	var _include_types:Array<ComponentType>;
	var _exclude_types:Array<ComponentType>;

	var _init_vars:InitVars;


	public function new(_name:String, ?_include:Array<Class<Dynamic>>, ?_exclude:Array<Class<Dynamic>>) {

		name = _name;
		
		onadded = new Signal();
		onremoved = new Signal();

		_include_types = [];
		_exclude_types = [];

		if(_include != null || _exclude != null) {
			_init_vars = {
				include : _include,
				exclude : _exclude
			};
		}

	}

	public function init(_w:World) {

		if(!inited) {
			_world = _w;
			_components = _world.components;
			_entities = new EntityVector(_world.entities.capacity);

			if(_init_vars != null) {
				var _include = _init_vars.include;
				if(_include != null) {
					include(_include);
				}
				var _exclude = _init_vars.exclude;
				if(_exclude != null) {
					exclude(_exclude);
				}
				_init_vars = null;
			}

		} else {
			throw('Family already inited');
		}

	}

	public function include(_comps:Array<Class<Dynamic>>):Family {

		var ct:ComponentType;
		for (c in _comps) {
			ct = _components.get_type(c);
			_include_types.push(ct);
		}

        return this;

	}

	public function exclude(_comps:Array<Class<Dynamic>>):Family {

		var ct:ComponentType;
		for (c in _comps) {
			ct = _components.get_type(c);
			_exclude_types.push(ct);
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

	function component_added(e:Entity, ct:ComponentType) {

		if(!_has(e) && _match_entity(e)) {
			_add(e);
		}
		
	}

	function component_removed(e:Entity, ct:ComponentType) {

		if(_has(e) && _match_include(ct)) {
			_remove(e);
		}

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
		
		var _match:Bool = true;

		for (ct in _exclude_types) {
			if(_match_component(e, ct)) {
				_match = false;
				break;
			}
		}

		if(_match) {
			for (ct in _include_types) {
				if(!_match_component(e, ct)) {
					_match = false;
					break;
				}
			}
		}

		return _match;

	}

	@:access(clay.core.ComponentManager)
	inline function _match_component(e:Entity, ct:ComponentType):Bool {
		
		return _components._has(e, ct.id);

	}

	function _match_include(ct:ComponentType):Bool {

		var _match:Bool = false;

		for (it in _include_types) {
			if(it == ct) {
				_match = true;
				break;
			}
		}

		return _match;

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


private typedef InitVars = {

	var include : Array<Class<Dynamic>>;
	var exclude : Array<Class<Dynamic>>;

}
