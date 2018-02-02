package clay;


import clay.Entity;
import clay.core.ComponentManager;
import clay.types.ComponentType;
import haxe.ds.Vector;


@:access(clay.core.ComponentManager)
class Components<T> {


	var manager:ComponentManager;
	var type:ComponentType;
	var components:Vector<T>;


	public function new(_manager:ComponentManager, _ctype:ComponentType) {

		type = _ctype;
		manager = _manager;
		components = new Vector(manager.entities.capacity);

	}

	public function set(e:Entity, c:T, notify:Bool = true):T {

		remove(e);

		components[e.id] = c;
		manager.flags[e.id].set_true(type.id + 1);

		if(notify) {
			manager.entity_changed(e);
		}

		return c;

	}

	public inline function get(e:Entity):T {

		return components[e.id];

	}

	public inline function copy(from:Entity, to:Entity) {

		var c = components[from.id];
		components[to.id] = c;
		manager.flags[to.id].set_true(type.id + 1);
		manager.entity_changed(to);

	}

	public inline function has(e:Entity):Bool {
		
		return components[e.id] != null;

	}

	public function remove(e:Entity):Bool {

		var _has:Bool = has(e);
		
		if(_has) {
			manager.flags[e.id].set_false(type.id + 1);
			manager.entity_changed(e);
			components[e.id] = null;
		}

		return _has;

	}

	@:access(clay.Entity)
	public function clear() {
		
		for (i in 0...components.length) {
			if(components[i] != null) {
				manager.entity_changed(new Entity(i));
				components[i] = null;
				manager.flags[i].set_false(type.id + 1);
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

		var entslen:Int = manager.entities.capacity;
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

