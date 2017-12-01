package test.claytest.processors;


import clay.Processor;
import clay.Family;
import test.claytest.components.MockComponent;
import test.claytest.components.MockComponent2;
import test.claytest.components.MockComponentExtended;


class ProcessorA extends Processor {


	public var family_a:Family;
	public var family_b:Family;


	public function new():Void {
		
		super();
		
	}

	override function onadded() {

		family_a = world.families.get('family_a');
		family_b = world.families.get('family_b');
	    
	}

	// override function update(dt:Float) {

	  //   for (e in test_family) {

	  //   	var ca = compA.get(e);

			// // trace(ca.);
			// // trace('ca == null');
	  //   }


	// }



}
