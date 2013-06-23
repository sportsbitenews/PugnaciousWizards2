package payloads 
{
	public class Pierce implements Payload
	{
		public function hitCreature(creature:Creature):void
		{
			creature.takeDamage(2, "Killed by a piercing blow.");
			creature.bleed(5);
		}
		
		public function hitTile(world:World, x:int, y:int):void 
		{
		}
	}
}