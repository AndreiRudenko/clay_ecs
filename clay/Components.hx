package clay;


import clay.World;
import clay.Entity;
import clay.core.ComponentManager;
import clay.types.ComponentType;
import haxe.ds.Vector;


@:access(clay.core.ComponentManager)
@:access(clay.core.FamilyManager)
class Components<T> {


	var world:World;
	var type:ComponentType;
	var components:Vector<T>;


	public function new(_world:World, _ctype:ComponentType) {

		type = _ctype;
		world = _world;
		components = new Vector(world.entities.capacity);

	}

	public function set(e:Entity, c:T, notify:Bool = true):T {

		remove(e);

		components[e.id] = c;

		if(notify) {
			world.families.component_added(e, type);
		}

		return c;

	}

	public inline function get(e:Entity):T {

		return components[e.id];

	}

	public inline function copy(from:Entity, to:Entity) {

		components[to.id] = components[from.id];
		world.families.component_added(to, type);

	}

	public inline function has(e:Entity):Bool {
		
		return components[e.id] != null;

	}

	public function remove(e:Entity):Bool {

		var _has:Bool = has(e);

		if(_has) {
			world.families.component_removed(e, type);
			components[e.id] = null;
		}

		return _has;

	}

	@:access(clay.Entity)
	public function clear() {
		
		for (i in 0...components.length) {
			if(components[i] != null) {
				world.families.component_removed(new Entity(i), type);
				components[i] = null;
			}
		}

	}

	@:noCompletion public function toString() {
		var cm = world.components;
		var cname:String = '';
		for (k in cm.types.keys()) {
			var ct = cm.types.get(k);
			if(ct.id == type.id) {
				cname = k;
				break;
			}
		}

		var entslen:Int = world.entities.capacity;
		var comps:Int = 0;

		var arr = [];
		for (j in 0...entslen) {
			if(components[j] != null) {
				arr.push(j);
				comps++;
			}
		}

		return '${cname}: count: $comps [${arr.join(", ")}]';

	}


}

