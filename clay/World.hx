package clay;


// import clay.Entity;
// import clay.IComponent;
import clay.core.EntityManager;
import clay.core.ComponentManager;
import clay.core.ProcessorManager;
import clay.core.FamilyManager;
import clay.Components;
import clay.Family;
import clay.signals.Signal;
import clay.utils.Log.*;


class World {


	public var name       	(default, null): String;
	public var inited     	(default, null): Bool = false;

	public var entities   	(default, null): EntityManager;
	public var components 	(default, null): ComponentManager;
	public var families   	(default, null): FamilyManager;
	public var processors 	(default, null): ProcessorManager;

	public var oninit   	(default, null):Signal<World->Void>;
	public var ondestroy	(default, null):Signal<World->Void>;
	public var onchanged	(default, null):Signal<World->Void>;

	@:noCompletion public var _has_changed : Bool = false;


	public function new(_name:String = 'default_world', _capacity:Int = 16384) {

		name = _name;

		if((_capacity & (_capacity - 1)) != 0) {
			throw('World capacity: $_capacity must be power of two');
		}

		oninit = new Signal();
		onchanged = new Signal();
		ondestroy = new Signal();

		entities = new EntityManager(this, _capacity);
		components = new ComponentManager(this);
		families = new FamilyManager(this);
		processors = new ProcessorManager(this);
		
	}

	public function init() {

		processors.init();
		inited = true;
		oninit.emit(this);
		
	}

	public function update(dt:Float) {

		if(inited) {
			processors.update(dt);
		}
		
	}

	public function destroy() {

		_debug('destroy world: "${name}"');

		ondestroy.emit(this);
		
		empty();

		oninit = null;
		onchanged = null;
		ondestroy = null;

		entities = null;
		components = null;
		families = null;
		processors = null;

	}

	public function empty() {

		entities.clear();
		components.clear();
		families.clear();
		processors.clear();
		_debug('empty world: "${name}"');

	}

	public inline function changed() {

		_has_changed = true;	
		onchanged.emit(this);
		
	}

}
