package themes
{
	import flash.geom.Point;
	
	public class TreasureRoom implements RoomTheme
	{
		public function apply(room:Room, world:World):void
		{
			if (room.isEndRoom)
				world.addItem(room.worldPosition.x + 3, room.worldPosition.y + 3, new EndPiece());
			else if (Math.random() < Globals.rarePercent)
				bigTreasure(room, world);
			else
				normalTreasure(room, world);
				
			addRoomArchitecture(room, world);
		}
		
		private function normalTreasure(room:Room, world:World):void 
		{
			world.addItem(room.worldPosition.x + 3, room.worldPosition.y + 3, new HealthContainer());
		}
		
		private function bigTreasure(room:Room, world:World):void 
		{
			world.addItem(room.worldPosition.x + 2, room.worldPosition.y + 2, new HealthContainer());
			world.addItem(room.worldPosition.x + 2, room.worldPosition.y + 4, new HealthContainer());
			world.addItem(room.worldPosition.x + 4, room.worldPosition.y + 4, new HealthContainer());
			world.addItem(room.worldPosition.x + 4, room.worldPosition.y + 2, new HealthContainer());
		}
		
		private function addPool(world:World, x:int, y:int):void 
		{
			world.addTile(x + 0, y + 0, Tile.shallow_water);
			world.addTile(x + 1, y + 0, Tile.shallow_water);
			world.addTile(x + 1, y + 1, Tile.shallow_water);
			world.addTile(x + 0, y + 1, Tile.shallow_water);
		}
		
		public function addRoomArchitecture(room:Room, world:World):void
		{
			var r:Number = Math.random();
			
			if (r < 0.2)
			{
				world.addWall(room.worldPosition.x + 0, room.worldPosition.y + 0);
				world.addWall(room.worldPosition.x + 6, room.worldPosition.y + 0);
				world.addWall(room.worldPosition.x + 6, room.worldPosition.y + 6);
				world.addWall(room.worldPosition.x + 0, room.worldPosition.y + 6);
			}
			else if (r < 0.4)
			{
				addPool(world, room.worldPosition.x + 1, room.worldPosition.y + 1);
				addPool(world, room.worldPosition.x + 4, room.worldPosition.y + 1);
				addPool(world, room.worldPosition.x + 4, room.worldPosition.y + 4);
				addPool(world, room.worldPosition.x + 1, room.worldPosition.y + 4);
			}
			else if (r < 0.6)
			{
				world.addTile(room.worldPosition.x + 1, room.worldPosition.y + 1, Tile.tree);
				world.addTile(room.worldPosition.x + 5, room.worldPosition.y + 1, Tile.tree);
				world.addTile(room.worldPosition.x + 5, room.worldPosition.y + 5, Tile.tree);
				world.addTile(room.worldPosition.x + 1, room.worldPosition.y + 5, Tile.tree);
			}
		}
	}
}