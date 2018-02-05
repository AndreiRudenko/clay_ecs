package clay.core;


import clay.utils.Log.*;

import clay.core.ComponentManager;
import clay.core.EntityManager;
import clay.core.FamilyManager;

@:access(clay.Processor)
class ProcessorManager {


		/** The list of processors */
	@:noCompletion public var _processors:Map<String, Processor>;
		/** Array of active processors */
	public var active_processors: Array<Processor>;
	
	var entities:EntityManager;
	var components:ComponentManager;
	var families:FamilyManager;

	var inited:Bool = false;


	public function new(_entities:EntityManager, _components:ComponentManager, _families:FamilyManager) {

		entities = _entities;
		components = _components;
		families = _families;

		_processors = new Map();
		active_processors = [];

	}

	public function init() {

		for (p in _processors) {
			p.init();
		}
		inited = true;
		
	}

	public function update(dt:Float) {
		
		for (p in active_processors) {
			p.update(dt);
		}
		
	}

	public function destroy() {

		for (p in _processors) {
			p.destroy();
		}

	} //destroy

	public function add<T:Processor>( _processor:T, priority:Int = 0, _enable:Bool = true ) : T {

		var _processor_class = Type.getClass(_processor);
		var _class_name = Type.getClassName(_processor_class);
		
		_processor.priority = priority;

		_processors.set( _class_name, _processor );

		_processor.entities = entities;
		_processor.components = components;
		_processor.families = families;
		_processor.processors = this;

		_processor.onadded();

		if(inited) {
			_processor.init();
		}

		if(_enable) {
			enable(_processor_class);
		}

		_debug('processors / adding a processor called ' + Type.getClass(_processor) + ', now at ' + Lambda.count(_processors) + ' processors');

		return _processor;
		
	} //add

	public function remove<T:Processor>( _processor_class:Class<T> ) : T {

		var _class_name = Type.getClassName(_processor_class);
		var _processor:T = cast _processors.get(_class_name);

		if(_processor != null) {

			if(_processor.active) {
				disable(_processor_class);
			}

			_processor.onremoved();

			_processor.entities = null;
			_processor.components = null;
			_processor.families = null;
			_processor.processors = null;

			_processors.remove(_class_name);

		}

		return _processor;

	}

	public function get<T:Processor>( _processor_class:Class<T> ):T {
		
		return cast _processors.get( Type.getClassName(_processor_class) );

	}

	public function enable( _processor_class:Class<Dynamic> ) {
		
		var _class_name = Type.getClassName(_processor_class);
		var _processor = _processors.get( _class_name );
		if(_processor != null && !_processor.active) {
			_debug('processors / enabling a processor ' + _class_name );
			_processor.onenabled();
			_processor._active = true;

			var added:Bool = false;
			var ap:Processor = null;
			for (i in 0...active_processors.length) {
				ap = active_processors[i];
				if (_processor.priority <= ap.priority) {
					active_processors.insert(i, _processor);
					added = true;
					break;
				}
			}
			if(!added) {
				active_processors.push(_processor);
			}

			_debug('processors / now at ${active_processors.length} active processors');
		}

	}

	public function disable( _processor_class:Class<Dynamic> ) {

		var _class_name = Type.getClassName(_processor_class);
		var _processor = _processors.get( _class_name );
		if(_processor != null && _processor.active) {
			_debug('processors / disabling a processor ' + _class_name );
			_processor.ondisabled();
			_processor._active = false;
			active_processors.remove(_processor);
			_debug('processors / now at ${active_processors.length} active processors');
		}
		
	}
	
		/** remove all processors from list */
	public inline function clear() {

		_debug('remove all processors');

		for (p in _processors) {
			disable(Type.getClass(p));
		}

		_processors = new Map();

	}

	@:noCompletion public inline function iterator():Iterator<Processor> {

		return _processors.iterator();

	}

	@:noCompletion public inline function toString() {

		return _processors.toString();

	}

}
