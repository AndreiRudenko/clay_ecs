package clay;


// import clay.Entity;
// import clay.IComponent;
import clay.core.EntityManager;
import clay.core.ComponentManager;
import clay.core.ProcessorManager;
import clay.core.FamilyManager;
import clay.Components;
import clay.Family;
import clay.utils.Log.*;


class World {


	public var name       	(default, null): String;
	public var inited     	(default, null): Bool = false;

	public var entities   	(default, null): EntityManager;
	public var components 	(default, null): ComponentManager;
	public var families   	(default, null): FamilyManager;
	public var processors 	(default, null): ProcessorManager;

	@:noCompletion public var _has_changed : Bool = false;


	public function new(?_options:WorldOptions) {

		var _capacity:Int = def(_options.capacity, 16384);
		name = def(_options.name, 'default_world');

		entities = new EntityManager(this, _capacity);
		components = new ComponentManager(this);
		families = new FamilyManager(this, _options.families);
		processors = new ProcessorManager(this, _options.processors);

		init();

		#if luxe
			if(Luxe.core.debug != null) {
				var _view:clay.debug.WorldDebugView = Luxe.core.debug.get_view('Clay World');
				if(_view != null) {
					_view.add_world(this);
				}
			}
		#end
		
	}

	function init() {

		families.init();
		processors.init();
		inited = true;
		
	}

	public function destroy() {

		_debug('destroy world: "${name}"');

		#if luxe
			if(Luxe.core.debug != null) {
				var _view:clay.debug.WorldDebugView = Luxe.core.debug.get_view('Clay World');
				if(_view != null) {
					_view.remove_world(this);
				}
			}
		#end

		empty();

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
		
	}

}



typedef WorldOptions = {

	@:optional var name : String;
	@:optional var capacity : Int;
	@:optional var families : Array<Family>;
	@:optional var processors : Array<Processor>;

}
