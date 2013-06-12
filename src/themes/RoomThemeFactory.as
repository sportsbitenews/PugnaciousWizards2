package themes 
{
	public class RoomThemeFactory 
	{
		private static var themeList:Array = [
			new EmptyRoom(),
			new Courtyard(),
			new TrapFloors(),
			new TrapWalls(),
			new TrapTower(),
			new RotatingTrapTower(),
			new RotatingTrapTower_4Way(),
			new MovingBlocks(),
			new GuardRoom(),
			new ArcherRoom(),
			new MysticRoom(),
			new GuardBarracks(),
			new ArcherBarracks(),
			new PortalRoom(),
			new PoolRoom(),
			new TrapRoom(),
		];
		
		public static function random():RoomTheme
		{
			return themeList[Math.floor(Math.random() * themeList.length)];
		}
	}
}