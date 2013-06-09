package spells 
{
	import animations.MagicMissileProjectile;
	import flash.geom.Point;
	import knave.Line;
	import knave.RL;
	import screens.TargetDirectionScreen;
	
	public class MagicMissile implements Spell
	{
		private var callback:Function;
		
		public function get name():String { return "Magic missile"; }
		
		public function playerCast(player:Creature, callback:Function):void
		{
			this.callback = callback;
			
			RL.current.enter(new TargetDirectionScreen(player, cast));
		}
		
		public function cast(caster:Creature, x:int, y:int):void
		{
			new MagicMissileProjectile(caster.world, caster.position.x, caster.position.y, x, y);
			if (callback != null)
				callback();
		}
		
		public function aiGetAction(ai:Hero):SpellCastAction
		{	
			for (var ox:int = -ai.visionRadius; ox < ai.visionRadius; ox++)
			for (var oy:int = -ai.visionRadius; oy < ai.visionRadius; oy++)
			{
				var x:int = ai.position.x + ox;
				var y:int = ai.position.y + oy;
				
				var other:Creature = ai.world.getCreatureAt(x, y);
				
				if (other == null || !ai.isEnemy(other))
					continue;
				
				if (!canShootTarget(ai, other))
					continue;
					
				return new SpellCastAction(75, function():void
				{
					new MagicMissile().cast(ai, 
								clamp(other.position.x - ai.position.x), 
								clamp(other.position.y - ai.position.y));
				});
			}
			
			return new SpellCastAction(0, function():void
			{
				new MagicMissile().cast(ai, 0, 0);
			});
		}
		
		private function clamp(n:int):int
		{
			return Math.max( -1, Math.min(n, 1));
		}
		
		private function canShootTarget(ai:Creature, other:Creature):Boolean 
		{
			if (!ai.canSeeCreature(other))
				return false;
				
			var isInCorrectDirection:Boolean = other.position.x - ai.position.x == 0 
											|| other.position.y == ai.position.y
											|| Math.abs(other.position.x - ai.position.x) 
											 - Math.abs(other.position.y - ai.position.y) == 0;
			if (!isInCorrectDirection)
				return false;
			
			for each (var point:Point in Line.betweenPoints(ai.position, other.position).points)
			{
				if (ai.world.getTile(point.x, point.y).blocksArrows)
					return false;
			}
			return true;
		}
	}
}