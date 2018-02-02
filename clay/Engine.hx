package clay;


class Engine {


	public var world:clay.World;
	public var worlds:clay.core.WorldManager;


    public function new(_capacity:Int = 16384) {

		worlds = new clay.core.WorldManager();

		world = new clay.World("world", _capacity);
		worlds.add(world);

	}

	public function destroy():Void {

		worlds.destroy();
		worlds = null;
		world = null;

	}


}
