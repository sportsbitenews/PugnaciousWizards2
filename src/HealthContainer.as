package  
{
	public class HealthContainer implements Item
	{
		public function get name():String { return "health container"; }
		
		public function getPickedUpBy(creature:Creature):void 
		{
			creature.world.removeItem(creature.position.x, creature.position.y);
			creature.health += 5;
			creature.maxHealth = Math.max(creature.health, creature.maxHealth);
		}
	}
}