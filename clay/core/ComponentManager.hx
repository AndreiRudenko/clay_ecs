package clay.core;

import clay.utils.Log.*;

import clay.Entity;
import clay.World;
import clay.core.FamilyManager;
import clay.Family;
import clay.types.ComponentType;
import clay.Components;


@:access(clay.core.FamilyManager)
@:access(clay.Family)
class ComponentManager {


	var world:World;
	var components:Array<Components<Dynamic>>;
	var types:Map<String, ComponentType>;
	var id:Int = 0;


	public function new(_world:World) {

		_debug('create new ComponentManager');

		world = _world;

		components = [];
		types = new Map();

	}

	public function get_table<T>(_component_class:Class<T>):Components<T> {
		
		var ct:ComponentType = get_type(_component_class);
		return cast components[ct.id];

	}

		/** add a component to the entity.
			@param _entity The entity.
			@param _component The component object to add.
			@param _component_class The class of the component. This is only necessary if the component
			extends another component class and you want the framework to treat the component as of
			the base class type. If not set, the class type is determined directly from the component.
			@return A reference to component. */
	public inline function set<T>(_entity:Entity, _component:T, ?_component_class:Class<Dynamic>):T {

		if(_component_class == null){
			_component_class = Type.getClass(_component);
		}

		var ct:ComponentType = get_type(_component_class);
		return cast components[ct.id].set(_entity, _component);

	}

		/** add a array of components to the entity.
			@param _entity The entity.
			@param _components Array of components to add. */
	public inline function set_many(_entity:Entity, _components:Array<Dynamic>) {

		var ct:ComponentType = new ComponentType(-1);
		for (c in _components) {
			ct = get_type(Type.getClass(c));
			components[ct.id].set(_entity, c, false); // don't notify families
		}
		// now we can check, and send events
		world.families.check(_entity);
	}

		/** get a component from the entity.
			@param _entity The entity.
			@param _component_class The class of the component requested.
			@return The component, or null if none was found. */
	public inline function get<T>(_entity:Entity, _component_class:Class<T>):T {

		var ct:ComponentType = get_type(_component_class);
		return cast components[ct.id].get(_entity);

	}

		/** get all components from the entity. */
	public function get_all(_entity:Entity):Array<Dynamic> {

		var ret:Array<Dynamic> = [];

		for (c in components) {
			var comp = c.get(_entity);
			if(comp != null) {
				ret.push(comp);
			}
		}

		return ret;

	}

		/** check if entity has component.
			@param _entity The entity.
			@param _component_class The class of the component requested.
			@return true, or false if none was found. */
	public inline function has(_entity:Entity, _component_class:Class<Dynamic>):Bool {

		var ct:ComponentType = get_type(_component_class);
		return _has(_entity, ct.id);

	}

		/** copy a component from the entity to other.
			@param _from The entity.
			@param _to The entity.
			@param _component_class The class of the component requested. */
	public inline function copy<T>(_from:Entity, _to:Entity, _component_class:Class<T>) {

		var ct:ComponentType = get_type(_component_class);
		components[ct.id].copy(_from, _to);

	}

		/** remove a component from the entity.
			@param _entity The entity.
			@param _component_class The class of the component to be removed.
			@return true if component removed. */
	public inline function remove(_entity:Entity, _component_class:Class<Dynamic>):Bool {

		var ct:ComponentType = get_type(_component_class);
		return components[ct.id].remove(_entity);

	}

		/** remove all components from the entity */
	public function remove_all(_entity:Entity) {

		for (c in components) {
			c.remove(_entity);
		}

	}

		/** remove all components */
	public function clear() {

		_debug('destroy and remove all components');

	}

		/** destroy ComponentManager */
	@:noCompletion public function destroy_manager() {

		_debug('destroy ComponentManager');
		
		clear();
		
	}

	@:noCompletion public function get_type<T>(_component:Class<T>):ComponentType {

		var ct:ComponentType = new ComponentType(-1);
		var tname:String = Type.getClassName(_component);
		if(types.exists(tname)) {
			ct = types.get(tname);
		} else {
			ct = new ComponentType(id++);
			types.set(tname, ct);
			components[ct.id] = new Components<T>(world, ct);
		}

		return ct;
		
	}

	inline function _has(e:Entity, cid:Int):Bool {

		return components[cid].has(e);
		
	}

	@:noCompletion public function toString() {

		var _list = []; 

		var len:Int = components.length;
		var comps:Int = 0;

		for (i in 0...len) {
			var cd = components[i];
			if(cd != null) { 
				_list.push(cd.toString());
			}
		}

		return 'types:$len / components: $comps / ${_list.join(", ")}';

	}


}