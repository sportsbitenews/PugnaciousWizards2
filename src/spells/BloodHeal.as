package spells 
{
	import animations.Flash;
	
	public class BloodHeal implements Spell 
	{
		public function get name():String { return "Blood Heal"; }
		
		public function get description():String { return "Restore health based on how much blood you see."; }
		
		
		public function playerCast(player:Creature, callback:Function):void 
		{
			cast(player, 0, 0);
			callback();
		}
		
		public function cast(caster:Creature, x:int, y:int):void 
		{
			var total:int = 0;
			
			caster.foreachVisibleLocation(function (vx:int, vy:int):void {
				var blood:int = caster.world.getBlood(vx, vy);
				
				if (blood == 0)
					return;
					
				new Flash(caster.world, vx, vy);
				
				caster.world.addBlood(vx, vy, -blood);
				total += blood;
			});
			caster.heal(total / 2);
		}
		
		private function getVisibleBloodCount(caster:Creature):int
		{
			var count:int = 0;
			caster.foreachVisibleLocation(function (vx:int, vy:int):void {
					count += caster.world.getBlood(vx, vy);
			});
			return count / 2;
		}
		
		public function aiGetAction(ai:Creature):SpellCastAction 
		{
			var chance:Number = 0.00;
			if (ai.health < 30)
				chance = 0.80;
			else if (ai.health < 60)
				chance = 0.40;
			else if (ai.health < 90)
				chance = 0.10;
					
			if (chance > 0 && getVisibleBloodCount(ai) == 0)
				chance = 0;
			
			return new SpellCastAction(chance, function():void {
				cast(ai, 0, 0);
			});
		}
	}
}