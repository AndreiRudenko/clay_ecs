package clay.containers;


import clay.Entity;
import clay.ds.BitVector;
import haxe.ds.Vector;


@:final @:unreflective @:dce
class EntityVector {


	public var length(default, null):Int;

	public var indexes(default, null):Vector<Int>;
	var buffer(default, null):Vector<Int>;


	public inline function new(_capacity:Int) {

		length = 0;
		
		indexes = new Vector(_capacity);
		buffer = new Vector(_capacity);

		for (i in 0..._capacity) {
			indexes[i] = -1;
		}

	}

	public inline function add(e:Entity) {

		if(!_has(e.id)) {
			_add(e.id);
		}

	}

	public inline function add_unsafe(e:Entity) {

		_add(e.id);

	}

	public inline function has(e:Entity):Bool {

		return _has(e.id);

	}

	@:access(clay.Entity)
	public inline function get(_index:Int):Entity { // todo

		return new Entity(_index);

	}

	public inline function remove(e:Entity) {

		if(_has(e.id)) {
			_remove(e.id);
		}

	}

	public inline function remove_unsafe(e:Entity) {

		_remove(e.id);

	}

	public inline function reset() {

		for (i in 0...indexes.length) {
			indexes[i] = -1;
		}

		length = 0;

	}

	inline function _add(id:Int) {

		buffer[length] = id;
		indexes[id] = length;
		length++;

	}

	inline function _remove(id:Int) {

		var idx:Int = indexes[id];

		var last_idx:Int = length - 1;
		if(idx != last_idx) {
			var last_id:Int = buffer[last_idx];
			buffer[idx] = last_id;
			indexes[last_id] = idx;
		}

		indexes[id] = -1;

		length--;

	}

	inline function _has(_idx:Int):Bool {

		return indexes[_idx] != -1;

	}

	inline function toString() {

		var _list = []; 

		for (i in this.iterator()) {
			_list.push(i.id);
		}

		return '[${_list.join(", ")}]';

	}

	public inline function iterator():EntityVectorIterator {

		return new EntityVectorIterator(this);

	}


}


@:final @:unreflective @:dce
@:access(clay.containers.EntityVector)
class EntityVectorIterator {


	public var index:Int;
	public var end:Int;
	public var data:Vector<Int>;


	public inline function new(_vector:EntityVector) {

		index = 0;
		end = _vector.length;
		data = _vector.buffer;

	}

	public inline function hasNext():Bool {

		return index != end;

	}

	@:access(clay.Entity)
	public inline function next():Entity {

		return new Entity(data[index++]);

	}


}

