package themes 
{
	import features.CastleFeature;
	import features.MovingWall;
	import flash.geom.Point;
	public class MovingBlocks implements RoomTheme
	{
		public function apply(room:Room, world:World):void 
		{
			room.allowsVariation = false;
			
			switch ((int)(Math.random() * 3))
			{
				case 0: circles(room, world); break;
				case 1: northSouth(room, world); break;
				case 2: westEast(room, world); break;
			}
			
			for (var i:int = 0; i < 7; i++)
			{
				var x:int = Math.random() * 7;
				var y:int = Math.random() * 7;
				world.addBlood(room.worldPosition.x + x, room.worldPosition.y + y);
			}
		}
		
		private function layTrack(room:Room, world:World, tiles:Array):void
		{
			for (var x:int = 0; x < 7; x++)
			for (var y:int = 0; y < 7; y++)
			{
				var light:Boolean = (x + y) % 2 == 0;
				var tile:String = tiles[y].charAt(x);
				
				switch (tile)
				{
					case "|": world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, light ? Tile.track_light_ns : Tile.track_dark_ns); break;
					case "-": world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, light ? Tile.track_light_we : Tile.track_dark_we); break;
					case "3": world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, light ? Tile.track_light_nw : Tile.track_dark_nw); break;
					case "1": world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, light ? Tile.track_light_ne : Tile.track_dark_ne); break;
					case "9": world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, light ? Tile.track_light_sw : Tile.track_dark_sw); break;
					case "7": world.addTile(room.worldPosition.x + x, room.worldPosition.y + y, light ? Tile.track_light_se : Tile.track_dark_se); break;
				}
			}
		}
		
		private function circles(room:Room, world:World):void 
		{
			layTrack(room, world, [
				"7-----9",
				"|7---9|",
				"||7-9||",
				"||| |||",
				"||1-3||",
				"|1---3|",
				"1-----3",
			]);
			
			for each (var offset:int in [0,1,2,4,5,6])
			{
				var f:CastleFeature = new MovingWall(world, room.worldPosition.x + offset, room.worldPosition.y + offset);
				room.roomFeatures.push(f);
				world.addFeature(f);
			}
		}
		
		private function northSouth(room:Room, world:World):void 
		{
			layTrack(room, world, [
				"|||||||",
				"|||||||",
				"|||||||",
				"|||||||",
				"|||||||",
				"|||||||",
				"|||||||",
			]);
			
			for (var x:int = 0; x < 7; x++)
			{
				var y:int = Math.random() * 7;
				var f:CastleFeature = new MovingWall(world, room.worldPosition.x + x, room.worldPosition.y + y);
				room.roomFeatures.push(f);
				world.addFeature(f);
			}
		}
		
		private function westEast(room:Room, world:World):void 
		{
			layTrack(room, world, [
				"-------",
				"-------",
				"-------",
				"-------",
				"-------",
				"-------",
				"-------",
			]);
			
			for (var y:int = 0; y < 7; y++)
			{
				var x:int = Math.random() * 7;
				var f:CastleFeature = new MovingWall(world, room.worldPosition.x + x, room.worldPosition.y + y);
				room.roomFeatures.push(f);
				world.addFeature(f);
			}
		}
	}
}