package clay;


import clay.core.ComponentManager;
import clay.core.EntityManager;
import clay.core.FamilyManager;
import clay.core.ProcessorManager;
import clay.utils.Log.*;


class Processor {


	public var name(default, null):String;
	public var priority (default, set) : Int = 0;
	public var active (get, set) : Bool;
	var _active : Bool = false;

	var components:ComponentManager;
	var entities:EntityManager;
	var families:FamilyManager;
	var processors:ProcessorManager;

	@:noCompletion public var prev : Processor;
	@:noCompletion public var next : Processor;
	

	public function new() {

		name = Type.getClassName(Type.getClass(this));

		_debug('creating new processor: "${name}"');

	}

	public function destroy() {

		_debug('destroy processor "${name}"');

		_active = false;

		if(processors != null) {
			processors.remove(Type.getClass(this));
		}

	}

	function init() {}
	function onadded() {}
	function onremoved() {}
	function onenabled() {}
	function ondisabled() {}
	function onprioritychanged(value:Int) {}
	function update(dt:Float) {}

	@:access(clay.core.ProcessorManager)
	inline function set_priority(value:Int) : Int {
		
		_debug('set priority on "${name}" to : ${value}');

		priority = value;

		onprioritychanged(priority);

		if(processors != null && active) {
			processors._remove_active(this);
			processors._add_active(this);
		}

		return priority;

	}

	inline function get_active():Bool {

		return _active;

	}
	
	inline function set_active(value:Bool):Bool {

		_active = value;

		if(processors != null) {
			if(_active){
				processors.enable(Type.getClass(this));
			} else {
				processors.disable(Type.getClass(this));
			}
		}
		
		return _active;

	}


}
