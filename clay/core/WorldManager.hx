package clay.core;


import clay.World;
import clay.utils.Log.*;


class WorldManager {


    var worlds:Map<String, World>;


	public function new() {
		
		_debug('creating new WorldManager');
		worlds = new Map();

	}

	public function add(_world:World):World {

		_debug('add world: "${_world.name}"');

		handle_duplicate_warning(_world.name);

		worlds.set(_world.name, _world);

		return _world;

	}

	public inline function get(_name:String):World {

		return worlds.get(_name);

	}

	public function remove(_world:World):Bool {

		if(worlds.exists(_world.name)) {
			_debug('remove world: "${_world.name}"');
			worlds.remove( _world.name );
		} else {
			_debug('can`t remove world: "${_world.name}"');
		}

		return _world != null;

	}
		/** destroy WorldManager */
	@:noCompletion public function destroy() {

		_debug('destroy WorldManager');
		
		for (w in worlds) {
			w.destroy();
		}

		worlds = null;
		
	}

	inline function handle_duplicate_warning(_name:String) {

		var w:World = worlds.get(_name);
		if(w != null) {
			log('adding a second world named: "${_name}"!
				This will replace the existing one, possibly leaving the previous one in limbo.');
			remove(w);
		}

	}
	
	inline function toString() {

		var _list = []; 

		for (w in worlds) {
			_list.push(w.name);
		}

		return 'worlds: [${_list.join(", ")}]';

	}

	@:noCompletion public inline function iterator():Iterator<World> {

		return worlds.iterator();

	}

}