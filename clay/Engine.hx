package clay;


class Engine {


	public var world:clay.World;
	public var worlds:clay.core.WorldManager;


    public function new(?_options:clay.World.WorldOptions) {

		worlds = new clay.core.WorldManager();

		world = new clay.World(_options);
		worlds.add(world);

	}

	public function destroy():Void {

		worlds.destroy();
		worlds = null;
		world = null;

	}


}
