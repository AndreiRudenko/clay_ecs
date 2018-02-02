package clay;


import clay.World;
import clay.utils.Log.*;


class Processor {


	public var name(default, null):String;
	public var priority (default, set) : Int = 0;
	public var active (get, set) : Bool;
	var _active : Bool = false;

	var world:World;

	@:noCompletion public var prev : Processor;
	@:noCompletion public var next : Processor;
	

	public function new() {

		name = Type.getClassName(Type.getClass(this));

		_debug('creating new processor: "${name}"');

	}

	public function destroy() {

		_debug('destroy processor "${name}"');

		_active = false;

		if(world != null) {
			world.processors.remove(Type.getClass(this));
		}

	}

	function init() {}
	function onadded() {}
	function onremoved() {}
	function onenabled() {}
	function ondisabled() {}
	function onprioritychanged(value:Int) {}
	function update(dt:Float) {}

	inline function set_priority(value:Int) : Int {
		
		_debug('set priority on "${name}" to : ${value}');

        priority = value;

        onprioritychanged(priority);

        if(world != null) {
            world.processors.active_processors.remove( this );
            world.processors.active_processors.add( this );
        }

        return priority;

	}

	inline function get_active():Bool {

		return _active;

	}
	
	inline function set_active(value:Bool):Bool {

		_active = value;

		if(world != null) {
			if(_active){
				world.processors.enable(Type.getClass(this));
			} else {
				world.processors.disable(Type.getClass(this));
			}
		}
		
		return _active;

	}


}
