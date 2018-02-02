package clay.core;


import clay.utils.Log.*;

import clay.containers.ProcessorList;
import clay.ds.ClassMap;
import clay.World;

@:access(clay.Processor)
class ProcessorManager {


		/** The list of processors */
	@:noCompletion public var _processors:ClassMap<Class<Dynamic>, Processor>;
		/** The ordered list of active processors */
	public var active_processors: ProcessorList;
	
	var world:World;

	var processors_count:Int = 0;
	var active_count:Int = 0;


	public function new(_world:World, ?_procs:Array<Processor>) {

		world = _world;

		_processors = new ClassMap();
		active_processors = new ProcessorList();

		if(_procs != null) {
			for (i in 0..._procs.length) {
				add(_procs[i], i);
			}
		}

	}

	public function init() {

		for (p in _processors) {
			p.init();
		}
		
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
		
			// set priority
		_processor.priority = priority;

			//store it in the processor list
		_processors.set( _processor_class, _processor );
		processors_count++;
			//store reference of the owner
		_processor.world = world;

			//let them know
		_processor.onadded();

			//if this processor is added
			//after init has happened,
			//it should init immediately
		if(world.inited) {
				// init families etc
			_processor.init();
		}

			// enable processor
		if(_enable) {
			enable(_processor_class);
		}

			//debug stuff
		_debug('processors / adding a processor called ' + Type.getClass(_processor) + ', now at ' + Lambda.count(_processors) + ' processors');

		world.changed();

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

				_processor.world = null;

					//remove it
				_processors.remove(_processor_class);
				processors_count--;

			} //processor != null
			
			world.changed();

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

@:noCompletion
@:allow(clay.core.ProcessorManager)
class Tag {
	static var processors_update           = 'clay.processors.update';
	static var processors_render           = 'clay.processors.render';
	static var processors_prerender        = 'clay.processors.prerender';
	static var processors_postrender       = 'clay.processors.postrender';
}