package clay.ds;


import haxe.ds.Vector;


@:final @:unreflective @:dce
class IntVector {


	public var length(default, null):Int = 0;

	public var indexes(default, null):Vector<Int>;
	var buffer(default, null):Vector<Int>;


	public inline function new(_capacity:Int = 16) {

		indexes = new Vector(_capacity);
		for (i in 0...indexes.length) {
			indexes[i] = -1;
		}

		buffer = new Vector(_capacity);

	}

	public inline function add(id:Int) {

		if(!has(id)) {
			_add(id);
		}

	}

	public inline function has(id:Int):Bool {

		return indexes[id] != -1;

	}

	public inline function remove(id:Int) {

		if(has(id)) {
			_remove(id);
		}

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

	inline function toString() {

		var _list = []; 

		for (i in this.iterator()) {
			_list.push(i);
		}

		return '[${_list.join(", ")}]';

	}

	public inline function iterator():IntVectorIterator {

		return new IntVectorIterator(this);

	}


}


@:final @:unreflective @:dce
@:access(clay.ds.IntVector)
class IntVectorIterator {


	public var index:Int;
	public var end:Int;
	public var data:Vector<Int>;


	public inline function new(_vector:IntVector) {

		index = 0;
		end = _vector.length;
		data = _vector.buffer;

	}

	public inline function hasNext():Bool {

		return index != end;

	}

	public inline function next():Int {

		return data[index++];

	}


}

