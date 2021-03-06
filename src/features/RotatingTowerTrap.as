package features
{
	import animations.Arrow;
	import payloads.Fire;
	import payloads.Ice;
	import payloads.Payload;
	import payloads.PayloadFactory;
	import payloads.Poison;
	
	public class RotatingTowerTrap extends CastleFeature
	{
		private static var directions:Array = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"];
		
		public var x:int;
		public var y:int;
		public var world:World;
		public var directionIndex:int;
		public function get direction():String { return directions[directionIndex]; }
		public var payload:Payload;
		
		public function RotatingTowerTrap(world:World, x:int, y:int) 
		{
			this.world = world;
			this.x = x;
			this.y = y;
			this.directionIndex = (int)(Math.random() * 8);
			this.payload = PayloadFactory.random();
			
			updateWorld();
		}
		
		override public function contains(x:int, y:int):Boolean
		{
			return this.x == x && this.y == y;
		}
		
		override public function retheme(payload:Payload):void
		{
			this.payload = payload;
		}
		
		override public function update():void
		{
			directionIndex++;
			if (directionIndex == 8)
				directionIndex = 0;
			
			updateWorld();
			
			new Arrow(world, x, y, directions[directionIndex], payload);
			new Arrow(world, x, y, directions[(directionIndex + 4) % 8], payload);
		}
		
		private function updateWorld():void
		{
			if (payload is Ice)
				updateWorld_ice();
			else if (payload is Fire)
				updateWorld_fire();
			else if (payload is Poison)
				updateWorld_poison();
			else
				updateWorld_piercing();
		}
		
		private function updateWorld_ice():void
		{
			switch (direction)
			{
				case "N":
				case "S":
					world.addTile(x, y, Tile.ice_tower_1);
					break;
				case "NE":
				case "SW":
					world.addTile(x, y, Tile.ice_tower_2);
					break;
				case "E":
				case "W":
					world.addTile(x, y, Tile.ice_tower_3);
					break;
				case "SE":
				case "NW":
					world.addTile(x, y, Tile.ice_tower_4);
					break;
			}
		}
		
		private function updateWorld_fire():void
		{
			switch (direction)
			{
				case "N":
				case "S":
					world.addTile(x, y, Tile.fire_tower_1);
					break;
				case "NE":
				case "SW":
					world.addTile(x, y, Tile.fire_tower_2);
					break;
				case "E":
				case "W":
					world.addTile(x, y, Tile.fire_tower_3);
					break;
				case "SE":
				case "NW":
					world.addTile(x, y, Tile.fire_tower_4);
					break;
			}
		}
		
		private function updateWorld_poison():void
		{
			switch (direction)
			{
				case "N":
				case "S":
					world.addTile(x, y, Tile.poison_tower_1);
					break;
				case "NE":
				case "SW":
					world.addTile(x, y, Tile.poison_tower_2);
					break;
				case "E":
				case "W":
					world.addTile(x, y, Tile.poison_tower_3);
					break;
				case "SE":
				case "NW":
					world.addTile(x, y, Tile.poison_tower_4);
					break;
			}
		}
		
		private function updateWorld_piercing():void
		{
			switch (direction)
			{
				case "N":
				case "S":
					world.addTile(x, y, Tile.tower_1);
					break;
				case "NE":
				case "SW":
					world.addTile(x, y, Tile.tower_2);
					break;
				case "E":
				case "W":
					world.addTile(x, y, Tile.tower_3);
					break;
				case "SE":
				case "NW":
					world.addTile(x, y, Tile.tower_4);
					break;
			}
		}
	}
}