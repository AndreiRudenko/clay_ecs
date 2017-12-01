package clay.ds;


import haxe.ds.Vector;


abstract BitVector(Vector<Int>) from Vector<Int> {
	

	public inline static var BITS_PER_ELEMENT:Int = 32;
	public inline static var BIT_SHIFT:Int = 5;
	public inline static var BIT_MASK:Int = 0x1F;


	public inline function new(count:Int) {
	
		this = new Vector(Math.ceil(count / BITS_PER_ELEMENT));
	
		#if neko
		for(i in 0...this.length) {
		    this[i] = 0;
		}
		#end
	
	}

	public inline function enable(index:Int) {

		this[address(index)] |= mask(index);
	
	}

	public inline function disable(index:Int) {

		this[address(index)] &= ~(mask(index));
	
	}

	@:arrayAccess
	public inline function get(index:Int):Bool {

		return (this[address(index)] & mask(index)) != 0;
	
	}

	@:arrayAccess
	public inline function set(index:Int, value:Bool):Void {

		value ? enable(index) : disable(index);
	
	}

	public inline function is_false(index:Int):Bool {

		return (this[address(index)] & mask(index)) == 0;
	
	}

	public inline function enable_if_not(index:Int):Bool {
	
		var a = address(index);
		var m = mask(index);
		var v = this[a];
		if((v & m) == 0) {
			this[a] = v | m;
			return true;
		}
		return false;
	
	}

	public function clear() {

		for (i in 0...this.length) {
			this[i] = 0;
		}
		
	}

	public inline function get_object_size():Int {

		return this.length << 2;
	
	}

	inline function toString() {

		var _list = []; 

		for (i in 0...(this.length << BIT_SHIFT)) {
			_list.push(get(i));
		}

		return '[${_list.join(", ")}]';

	}

	@:pure
	public inline static function address(index:Int):Int {

		return index >>> BIT_SHIFT;
	
	}

	@:pure
	public inline static function mask(index:Int):Int {

		return 0x1 << (index & BIT_MASK);

	}


}
