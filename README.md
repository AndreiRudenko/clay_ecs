# Clay
Entity-Component-System in haxe.

##### Usage
```haxe
import clay.Entity;
import clay.Processor;
import clay.World;
import clay.Family;
import clay.Components;


class ComponentA {

	public var string : String;

	public function new( _string:String ) : Void {
		string = _string;
	}

}

class ComponentB {

	public var int : Int;

	public function new( _int:Int ) : Void {
		int = _int;
	}

}

class ProcessorA extends Processor {


	var ab_family:Family;
	var a_comps:Components<ComponentA>;
	var b_comps:Components<ComponentB>;


	public function new() {

		super();

	}

	override function onadded() {

		a_comps = world.components.get_table(ComponentA);
		b_comps = world.components.get_table(ComponentB);

		ab_family = world.families.get('ab_family');

		ab_family.onadded.add(_entity_added);
		ab_family.onremoved.add(_entity_removed);

	}

	override function onremoved() {

		ab_family.onadded.remove(_entity_added);
		ab_family.onremoved.remove(_entity_removed);
		
	}

	override function update(dt:Float) {

		for (e in ab_family) {
			var a = a_comps.get(e);
			var b = b_comps.get(e);
			trace(a.string);
			trace(b.int);
		}

	}

	function _entity_added(e:Entity) {
		trace('entity: $e added');
	}
	
	function _entity_removed(e:Entity) {
		trace('entity: $e removed');
	}

}

class Main {

	static function main():Void {

		var world:World = new World('world', 16384);
		world.init();

		world.families.create('ab_family', [ComponentA, ComponentB]);
		world.processors.add(new ProcessorA());

		world.entities.create([new ComponentA('some_string'), new ComponentB(112358)]);
		world.entities.create([new ComponentA('other_string'), new ComponentB(1618)]);

		world.update(1/60);

	}

}


```

##### License
MIT