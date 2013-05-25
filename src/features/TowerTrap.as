package features
{
	import animations.Arrow;
	import payloads.Fire;
	import payloads.Magic;
	import payloads.Payload;
	import payloads.PayloadFactory;
	import payloads.Pierce;
	
	public class TowerTrap extends CastleFeature
	{
		public var x:int;
		public var y:int;
		public var world:World;
		public var payload:Payload;
		
		public function TowerTrap(world:World, x:int, y:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			this.payload = PayloadFactory.random();
			
			if (payload is Magic)
				world.addTile(x, y, Tile.magic_tower);
			else if (payload is Fire)
				world.addTile(x, y, Tile.fire_tower);
			else
				world.addTile(x, y, Tile.tower);
		}
		
		override public function update():void
		{
			for each (var direction:String in ["N","E","S","W","NE","SE","SW","NW"])
				Main.addAnimation(new Arrow(world, x, y, direction, payload));
		}
	}
}