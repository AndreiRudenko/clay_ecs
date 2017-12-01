package test.claytest.processors;


import clay.Processor;


class ProcessorB extends Processor {


	// var test_family:Family<ComponentA>;
	// var compA:ComponentMapper<ComponentA>;
	// var compB:ComponentMapper<ComponentB>;
	// var compT:ComponentMapper<test.asd.TestComp>;
	// // var procT2:ProcessorLink<test.asd.TestProc2>;
	// // var procT:ProcessorLink<TestProc>;
	// var procB:ProcessorLink<ProcessorB>;


	public function new():Void {
		
		super();
		// test_family = new FamilyData(_w);
		// test_family.require(ComponentA, ComponentB);
		// trace(test_family);
	}

	override function onadded() {
	    

	}

	// override function update(dt:Float) {

	//     for (e in test_family) {

	//     	var ca = compA.get(e);

	// 		// trace(ca.);
	// 		// trace('ca == null');
	//     }


	// }



}
