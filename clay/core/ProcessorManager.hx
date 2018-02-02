package clay.core;


import clay.utils.Log.*;

import clay.core.ComponentManager;
import clay.core.EntityManager;
import clay.core.FamilyManager;

import clay.containers.ProcessorList;
import clay.ds.ClassMap;

@:access(clay.Processor)
class ProcessorManager {


		/** The list of processors */
	@:noCompletion public var _processors:ClassMap<Class<Dynamic>, Processor>;
		/** The ordered list of active processors */
	public var active_processors: ProcessorList;
	
	var entities:EntityManager;
	var components:ComponentManager;
	var families:FamilyManager;

	var processors_count:Int = 0;
	var active_count:Int = 0;
	var inited:Bool = false;


	public function new(_entities:EntityManager, _components:ComponentManager, _families:FamilyManager) {

		entities = _entities;
		components = _components;
		families = _families;

		_processors = new ClassMap();
		active_processors = new ProcessorList();

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

		if(processors_count > 0) {
			var node = active_processors.head;
			var _processor = null;
			while(node != null) {
				_processor = node;
				node = node.next;
				_processor.destroy();
			}
		}

	} //destroy

	public function add<T:Processor>( _processor:T, priority:Int = 0, _enable:Bool = true ) : T {

		var _processor_class = Type.getClass(_processor);
		
		_processor.priority = priority;

			//store it in the processor list
		_processors.set( _processor_class, _processor );
		processors_count++;

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

			//debug stuff
		_debug('processors / adding a processor called ' + Type.getClass(_processor) + ', now at ' + Lambda.count(_processors) + ' processors');

		return _processor;
		
	} //add

	public function remove<T:Processor>( _processor_class:Class<T> ) : T {

		if(_processors.exists(_processor_class)) {

			var _processor:T = cast _processors.get(_processor_class);

			if(_processor != null) {

					//if it's running disable it
				if(_processor.active) {
					disable(_processor_class);
				} //_processor.active

					//tell user
				_processor.onremoved();

				_processor.entities = null;
				_processor.components = null;
				_processor.families = null;
				_processor.processors = null;

					//remove it
				_processors.remove(_processor_class);
				processors_count--;

			} //processor != null

			return _processor;

		} //remove

		return null;

	} //remove

	public function get<T:Processor>( _processor_class:Class<T> ):T {
		
		return cast _processors.get( _processor_class );

	}

	public function enable( _processor_class:Class<Dynamic> ) {
		
		if(processors_count == 0) {
			return;
		}

		var _processor = _processors.get( _processor_class );
		if(_processor != null && !_processor.active) {
			_debug('processors / enabling a processor ' + _processor_class );
			_processor.onenabled();
			_processor._active = true;
			active_processors.add(_processor);
			active_count++;
			_debug('processors / now at ${active_processors.length} active processors');
		}

	} //enable

	public function disable( _processor_class:Class<Dynamic> ) {

		if(processors_count == 0) {
			return;
		}

		var _processor = _processors.get( _processor_class );
		if(_processor != null && _processor.active) {
			_debug('processors / disabling a processor ' + _processor_class );
			_processor.ondisabled();
			_processor._active = false;
			active_processors.remove(_processor);
			active_count--;
			_debug('processors / now at ${active_processors.length} active processors');
		}
		
	} //disable
	
		/** remove all processors from list */
	public inline function clear() {

		_debug('remove all processors');

		for (p in _processors.keys()) {
			disable(p);
		}

		_processors = new ClassMap();

	}

	@:noCompletion public inline function iterator():Iterator<Processor> {

		return _processors.iterator();

	}

	@:noCompletion public inline function toString() {

		return _processors.toString();

	}

}
