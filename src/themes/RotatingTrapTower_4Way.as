package themes
{
	import features.CastleFeature;
	import features.RotatingTowerTrap_4Way;
	
	public class RotatingTrapTower_4Way implements RoomTheme
	{
		public function get name():String { return "Tower"; }
		
		public function apply(room:Room, world:World):void
		{
			var total:int = (int)(room.distance / 6 + 1);
			
			if (Math.random() < CurrentGameVariables.rarePercent)
				total = 8;
				
			for (var i:int = 0; i < total; i++)
			{
				var px:int = Math.random() * 5 + 6;
				var py:int = Math.random() * 5 + 6;
				
				var f:CastleFeature = new RotatingTowerTrap_4Way(world, room.position.x * 8 + px, room.position.y * 8 + py);
				room.roomFeatures.push(f);
				world.addFeature(f);
			}
		}
	}
}