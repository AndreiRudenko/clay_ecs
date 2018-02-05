package clay;


@:dce @:final @:unreflective
abstract Entity(Int) {


	public static inline var ID_NULL:Int = -1;
	public static inline var NULL:Entity = new Entity(ID_NULL);
	

	public var id(get, never):Int;


	@:allow(clay.core.EntityManager)
	inline function new(id:Int):Void {

		this = id;

	}
	
	inline function get_id():Int {

		return this;

	}

	public inline function is_null():Bool {
		
		return this == ID_NULL;

	}

}