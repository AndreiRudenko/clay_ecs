package clay;


import clay.World;
import clay.Entity;
import clay.core.ComponentManager;
import clay.types.ComponentType;
import haxe.ds.Vector;


@:access(clay.core.ComponentManager)
class Components<T> {


	var type: ComponentType;
	var manager: ComponentManager;
	var components: Vector<T>;


	public function new(_manager:ComponentManager, _ctype:ComponentType, _capacity:Int) {

		type = _ctype;
		manager = _manager;
		components = new Vector(_capacity);

	}

	public function set(e:Entity, c:T):T {

		if(has(e)) {
			remove(e);
		}

		components[e.id] = c;
		manager._onadded(e, type);

		return c;

	}

	public inline function get(e:Entity):T {

		return components[e.id];

	}

	public inline function copy(from:Entity, to:Entity) {

		components[to.id] = components[from.id];
		manager._onadded(to, type);

	}

	public inline function has(e:Entity):Bool {
		
		return components[e.id] != null;

	}

	public function remove(e:Entity):Bool {

		var _has:Bool = has(e);

		if(_has) {
			manager._onremoved(e, type);
			components[e.id] = null;
		}

		return _has;

	}

	@:access(clay.Entity)
	public function clear() {
		
		for (i in 0...components.length) {
			if(components[i] != null) {
				manager._onremoved(new Entity(i), type);
				components[i] = null;
			}
		}

	}

	@:noCompletion public function toString() {

		var cname:String = '';
		for (k in manager.types.keys()) {
			var ct = manager.types.get(k);
			if(ct.id == type.id) {
				cname = k;
				break;
			}
		}

		var entslen:Int = manager.world.entities.capacity;
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

