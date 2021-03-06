package  
{
	import features.CastleFeature;
	import flash.display.InterpolationMethod;
	import flash.geom.Point;
	import knave.AStar;
	import payloads.Ice;
	import payloads.Payload;
	import payloads.Poison;
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
		
		public function retheme(world:World, payload:Payload):void
		{
			for each (var feature:CastleFeature in roomFeatures)
				feature.retheme(payload);
			
			var trap:Tile = Tile.fire_trap;
			if (payload is Ice)
				trap = Tile.ice_trap;
			else if (payload is Poison)
				trap = Tile.poison_trap;
				
			world.addTile(worldPosition.x + 1, worldPosition.y + 1, trap);
			world.addTile(worldPosition.x + 1, worldPosition.y + 5, trap);
			world.addTile(worldPosition.x + 5, worldPosition.y + 5, trap);
			world.addTile(worldPosition.x + 5, worldPosition.y + 1, trap);
				
			for (var x:int = 0; x < 7; x++)
			for (var y:int = 0; y < 7; y++)
				payload.hitTile(world, worldPosition.x + x, worldPosition.y + y);
		}
		
		public function apply(world:World):void
		{
			do
			{
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
				
			roomFeatures = [];
			
			for (var x:int = 0; x < 7; x++)
			for (var y:int = 0; y < 7; y++)
			{
				world.addTile(worldPosition.x + x, worldPosition.y + y, ((x + y) % 2) == 0 ? Tile.floor_light : Tile.floor_dark);
				
				world.removeCreatureAt(worldPosition.x + x, worldPosition.y + y);
				world.removeItemsAt(worldPosition.x + x, worldPosition.y + y);
			}
		}
		
		private function anyDoorIsBlocked(world:World):Boolean 
		{
			var doors:Array = [];
			if (isConnectedNorth)
				doors.push(new Point(worldPosition.x + 3, worldPosition.y - 1));
			if (isConnectedSouth)
				doors.push(new Point(worldPosition.x + 3, worldPosition.y + 7));
			if (isConnectedWest)
				doors.push(new Point(worldPosition.x - 1, worldPosition.y + 3));
			if (isConnectedEast)
				doors.push(new Point(worldPosition.x + 7, worldPosition.y + 3));
			
			var firstPoint:Point = new Point( -1, -1);
			while (world.getTile(firstPoint.x, firstPoint.y).blocksMovement
				&& world.getTile(firstPoint.x, firstPoint.y) != Tile.tree)
			{
				firstPoint.x = worldPosition.x + (int)(Math.random() * 3) + 2;
				firstPoint.y = worldPosition.y + (int)(Math.random() * 3) + 2;
			}
			
			var cardinal:AStar = new AStar(
				function (x:int, y:int):Boolean { return !world.getTile(x, y).blocksMovement 
															|| world.isClosedDoor(x, y)
															|| world.getTile(x, y) == Tile.tree; },
				firstPoint, false);
			
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
			var tile:Tile = Math.random() < 0.125 ? Tile.tree : Tile.wall;
			
			if (isConnectedNorth && Math.random() < 0.1)
			{
				tile = Math.random() < CurrentGameVariables.rarePercent ? Tile.golden_statue : (Math.random() < CurrentGameVariables.treeChance ? Tile.tree : Tile.wall);
				world.addTile(worldPosition.x + 2, worldPosition.y + 0, tile);
				world.addTile(worldPosition.x + 4, worldPosition.y + 0, tile);
			}
			if (isConnectedSouth  && Math.random() < 0.1)
			{
				tile = Math.random() < CurrentGameVariables.rarePercent ? Tile.golden_statue : (Math.random() < CurrentGameVariables.treeChance ? Tile.tree : Tile.wall);
				world.addTile(worldPosition.x + 2, worldPosition.y + 6, tile);
				world.addTile(worldPosition.x + 4, worldPosition.y + 6, tile);
			}
			if (isConnectedWest && Math.random() < 0.1)
			{
				tile = Math.random() < CurrentGameVariables.rarePercent ? Tile.golden_statue : (Math.random() < CurrentGameVariables.treeChance ? Tile.tree : Tile.wall);
				world.addTile(worldPosition.x + 0, worldPosition.y + 2, tile);
				world.addTile(worldPosition.x + 0, worldPosition.y + 4, tile);
			}
			if (isConnectedEast && Math.random() < 0.1)
			{
				tile = Math.random() < CurrentGameVariables.rarePercent ? Tile.golden_statue : (Math.random() < CurrentGameVariables.treeChance ? Tile.tree : Tile.wall);
				world.addTile(worldPosition.x + 6, worldPosition.y + 2, tile);
				world.addTile(worldPosition.x + 6, worldPosition.y + 4, tile);
			}
			
			var r:Number = Math.random();
			
			if (r < 0.50)
				return;
				
			tile = CurrentGameVariables.treeChance ? Tile.tree : Tile.wall;
			
			if (r < 0.75)
			{
				world.addTile(worldPosition.x + 0, worldPosition.y + 0, tile);
				world.addTile(worldPosition.x + 6, worldPosition.y + 0, tile);
				world.addTile(worldPosition.x + 6, worldPosition.y + 6, tile);
				world.addTile(worldPosition.x + 0, worldPosition.y + 6, tile);
				return;
			}
			
			switch ((int)(Math.random() * 4))
			{
				case 0:
					world.addTile(worldPosition.x + 1, worldPosition.y + 1, tile);
					world.addTile(worldPosition.x + 5, worldPosition.y + 1, tile);
					world.addTile(worldPosition.x + 5, worldPosition.y + 5, tile);
					world.addTile(worldPosition.x + 1, worldPosition.y + 5, tile);
					
					if (Math.random() < 0.25)
					{
						world.addTile(worldPosition.x + 1, worldPosition.y + 3, tile);
						world.addTile(worldPosition.x + 3, worldPosition.y + 1, tile);
						world.addTile(worldPosition.x + 3, worldPosition.y + 5, tile);
						world.addTile(worldPosition.x + 5, worldPosition.y + 3, tile);
					}
				break;
				case 1:
					world.addTile(worldPosition.x + 3, worldPosition.y + 3, tile);
					break;
				case 2:
					world.addTile(worldPosition.x + 1, worldPosition.y + 3, tile);
					world.addTile(worldPosition.x + 3, worldPosition.y + 1, tile);
					world.addTile(worldPosition.x + 3, worldPosition.y + 5, tile);
					world.addTile(worldPosition.x + 5, worldPosition.y + 3, tile);
					break;
				case 3:
					world.addTile(worldPosition.x + 2, worldPosition.y + 2, tile);
					world.addTile(worldPosition.x + 2, worldPosition.y + 4, tile);
					world.addTile(worldPosition.x + 4, worldPosition.y + 4, tile);
					world.addTile(worldPosition.x + 4, worldPosition.y + 2, tile);
					break;
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
				
				chance = 0.25;
			}
		}
		
		public function contains(x:int, y:int):Boolean 
		{
			return worldPosition.x <= x && worldPosition.y <= y && worldPosition.x + 7 > x && worldPosition.y + 7 > y;
		}
		
		private function addEnemies(world:World):void 
		{
			var px:int, py:int;
			
			var archerPercents:Number = CurrentGameVariables.archerCount / (CurrentGameVariables.archerCount + 1);
			while (Math.random() < archerPercents)
			{
				px = Math.random() * 7 + 1;
				py = Math.random() * 7 + 1;
				
				if (world.getTile(worldPosition.x + px, worldPosition.y + py).blocksMovement)
					continue;
				
				if (world.getCreature(worldPosition.x + px, worldPosition.y + py) != null)
					continue;
				
				world.addCreature(new Archer(new Point(worldPosition.x + px, worldPosition.y + py)));
			}
			
			var guardPercents:Number = CurrentGameVariables.guardCount / (CurrentGameVariables.guardCount + 1);
			while (Math.random() < guardPercents)
			{
				px = Math.random() * 7 + 1;
				py = Math.random() * 7 + 1;
				
				if (world.getTile(worldPosition.x + px, worldPosition.y + py).blocksMovement)
					continue;
				
				if (world.getCreature(worldPosition.x + px, worldPosition.y + py) != null)
					continue;
				
				world.addCreature(new Guard(new Point(worldPosition.x + px, worldPosition.y + py)));
			}
		}
	}
}