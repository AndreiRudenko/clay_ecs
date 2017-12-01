package clay;


import massive.munit.Assert;

import clay.Entity;
import clay.Engine;
import clay.Scene;
import clay.Processor;


@:access(clay.Processor)
class ProcessorTest {


	var engine:Engine;


	@Before
	public function createEngine():Void {

		engine = new Engine();

	}

	@After
	public function clearEngine():Void {

		engine = null;

	}


	@Test
	public function testProcessorHasNameByDefault():Void {

		var processor:Processor = new Processor();
		Assert.isTrue(processor.name.length > 0);

	}

	@Test
	public function testProcessorNameStoredAndReturned():Void {

		var name:String = "anything";
		var processor:Processor = new Processor({ name : name });
		Assert.isTrue(processor.name == "anything");

	}

	@Test
	public function testProcessorNameUnique():Void {

		var name:String = "anything";
		var processor:Processor = new Processor({ name : name, name_unique : true });
		Assert.isTrue(processor.name == 'anything.${processor.id}');

	}

	@Test
	public function testProcessorNameCanBeChanged():Void {
		
		var processor:Processor = new Processor( { name : "anything"} );
		processor.name = "otherThing";
		Assert.isTrue(processor.name == "otherThing");

	}

	@Test
	public function testProcessorAddToScene():Void {

		var scene:Scene = new Scene("scene1");

		var processor:Processor = new Processor();
		scene.addProcessor(processor);

		Assert.isTrue(processor.scene == scene);
		Assert.isTrue(scene.getProcessor(processor.name) == processor);

	}

	@Test
	public function testProcessorSetSceneToNull():Void {

		var scene:Scene = new Scene("scene1");

		var processor:Processor = new Processor();
		scene.addProcessor(processor);
		processor.scene = null;

		Assert.isTrue(processor.scene == null);
		Assert.isTrue(scene.getProcessor(processor.name) == null);

	}

	@Test
	public function testProcessorSetChangeAndReturnScene():Void {

		var scene:Scene = new Scene("scene1");
		var scene2:Scene = new Scene("scene2");

		var processor:Processor = new Processor();
		scene.addProcessor(processor); // add to scene
		processor.scene = scene2; // switch to scene2

		Assert.isTrue(processor.scene == scene2);
		Assert.isTrue(scene.getProcessor(processor.name) == null);
		Assert.isTrue(scene2.getProcessor(processor.name) == processor);

	}

	@Test
	public function sceneGetterReturnsAllTheProcessors():Void {

		var processor1:Processor = new Processor();
		engine.scene.addProcessor(processor1);
		var processor2:Processor = new Processor();
		engine.scene.addProcessor(processor2);

		Assert.isTrue(engine.scene.getProcessor(processor1.name) == processor1); 
		Assert.isTrue(engine.scene.getProcessor(processor2.name) == processor2); 

	}






}
