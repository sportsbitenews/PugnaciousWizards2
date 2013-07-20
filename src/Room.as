package  
{
	import features.CastleFeature;
	import flash.display.InterpolationMethod;
	import flash.geom.Point;
	import knave.AStar;
	import themes.RoomTheme;
	import themes.RoomThemeFactory;
	import themes.TreasureRoom;
	
	public class Room 
	{
		public var worldPosition:Point;
		public var position:Point;
		public var theme:RoomTheme;
		public var roomFeatures:Array = [];
		
		public var isConnectedNorth:Boolean = false;
		public var isConnectedSouth:Boolean = false;
		public var isConnectedWest:Boolean = false;
		public var isConnectedEast:Boolean = false;
		public var isEndRoom:Boolean = false;
		
		public var distance:int = 0;
		public var forbidMagic:Boolean = false;
		
		public function Room(x:int, y:int) 
		{
			position = new Point(x, y);
			worldPosition = new Point(x * 8 + 5, y * 8 + 5);
			theme = RoomThemeFactory.random();
		}
		
		public function get isDeadEnd():Boolean 
		{
			var connections:int = 0;
			if (isConnectedNorth) connections++;
			if (isConnectedSouth) connections++;
			if (isConnectedWest) connections++;
			if (isConnectedEast) connections++;
			
			return connections == 1;
		}
		
		public function apply(world:World):void
		{
			do
			{
				trace("applying " + position.x + "," + position.y);
				
				clear(world);
				
				if (isDeadEnd)
				{
					new TreasureRoom().apply(this, world);
				}
				else
				{
					addRandomArchitecture(world);
					addRoomArchitecture(world);
					
					theme.apply(this, world);
					
					addEnemies(world);
				}
			} 
			while (anyDoorIsBlocked(world))
		}
		
		private function clear(world:World):void 
		{
			for each (var feature:CastleFeature in roomFeatures)
				world.removeFeature(feature);
				
			for (var x:int = 0; x < 7; x++)
			for (var y:int = 0; y < 7; y++)
				world.addTile(worldPosition.x + x, worldPosition.y + y, ((x + y) % 2) == 0 ? Tile.floor_light : Tile.floor_dark);
		}
		
		private function anyDoorIsBlocked(world:World):Boolean 
		{
			if (isDeadEnd)
				return false;
			
			var doors:Array = [];
			if (isConnectedNorth)
				doors.push(new Point(worldPosition.x + 3, worldPosition.y));
			if (isConnectedSouth)
				doors.push(new Point(worldPosition.x + 3, worldPosition.y + 7));
			if (isConnectedWest)
				doors.push(new Point(worldPosition.x, worldPosition.y + 3));
			if (isConnectedEast)
				doors.push(new Point(worldPosition.x + 7, worldPosition.y + 3));
			
			var cardinal:AStar = new AStar(
				function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement 
						|| world.getTile(x, y) == Tile.tree
						|| world.getTile(x, y) == Tile.door_closed },
				doors.shift(),
				true);
			
			cardinal.offsets = [[ -1, 0], [1, 0], [0, -1], [0, 1]];
			
			for each (var other:Point in doors)
			{
				var path:Array = cardinal.pathTo(other);
						
				if (path == null || path.length == 0)
					return true;
			}
			return false;
		}
		
		public function addRoomArchitecture(world:World):void
		{
			var r:Number = Math.random();
			
			if (r < 0.125 * 2)
			{
				world.addTile(worldPosition.x + 0, worldPosition.y + 0, Tile.wall);
				world.addTile(worldPosition.x + 6, worldPosition.y + 0, Tile.wall);
				world.addTile(worldPosition.x + 6, worldPosition.y + 6, Tile.wall);
				world.addTile(worldPosition.x + 0, worldPosition.y + 6, Tile.wall);
			}
			else if (r < 0.125 * 3)
			{
				world.addTile(worldPosition.x + 1, worldPosition.y + 1, Tile.wall);
				world.addTile(worldPosition.x + 5, worldPosition.y + 1, Tile.wall);
				world.addTile(worldPosition.x + 5, worldPosition.y + 5, Tile.wall);
				world.addTile(worldPosition.x + 1, worldPosition.y + 5, Tile.wall);
				
				if (Math.random() < 0.25)
				{
					world.addTile(worldPosition.x + 1, worldPosition.y + 3, Tile.wall);
					world.addTile(worldPosition.x + 3, worldPosition.y + 1, Tile.wall);
					world.addTile(worldPosition.x + 3, worldPosition.y + 5, Tile.wall);
					world.addTile(worldPosition.x + 5, worldPosition.y + 3, Tile.wall);
				}
			}
		}
				
		public function addRandomArchitecture(world:World):void
		{
			var chance:Number = 75;
			while (Math.random() < chance)
			{
				var px:int = Math.random() * 7;
				var py:int = Math.random() * 7;
				world.addTile(worldPosition.x + px, worldPosition.y + py, Tile.wall);
				
				chance = 0.50;
			}
		}
		
		public function contains(x:int, y:int):Boolean 
		{
			return worldPosition.x <= x && worldPosition.y <= y && worldPosition.x + 7 > x && worldPosition.y + 7 > y;
		}
		
		private function addEnemies(world:World):void 
		{
			while (Math.random() < 0.5)
			{
				var px:int = Math.random() * 7 + 1;
				var py:int = Math.random() * 7 + 1;
				
				if (world.getTile(worldPosition.x + px, worldPosition.y + py).blocksMovement)
					continue;
				
				if (world.getCreature(worldPosition.x + px, worldPosition.y + py) != null)
					continue;
				
				if (Math.random() < 66)
					world.addCreature(new Guard(new Point(worldPosition.x + px, worldPosition.y + py)));
				else
					world.addCreature(new Archer(new Point(worldPosition.x + px, worldPosition.y + py)));
			}
		}
	}
}