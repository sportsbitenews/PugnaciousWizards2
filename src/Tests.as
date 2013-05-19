package  
{
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	public class Tests 
	{
		public var passed:Boolean = true;
		public function get failed():Boolean { return !passed; }
		
		public var message:String = "ok";
		
		public function run():void
		{
			movement();
			movementKeys();
		}
		
		private function movementKeys():void 
		{
			var player:Player = new Player(new Point(5, 5));
			var playscreen:PlayScreen = new PlayScreen(player);
			
			playscreen.handleInput(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 39, 39));
			assertEqual(player.position.x, 6);
			assertEqual(player.position.y, 5);
			
			playscreen.handleInput(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 37, 37));
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 5);
			
			playscreen.handleInput(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 40, 40));
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 6);
			
			playscreen.handleInput(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 38, 38));
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 5);
		}
		
		private function movement():void 
		{
			var player:Player = new Player(new Point(5, 5));
			
			player.moveBy(1, 0);
			assertEqual(player.position.x, 6);
			assertEqual(player.position.y, 5);
			
			player.moveBy(-1, 0);
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 5);
			
			player.moveBy(0, 1);
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 6);
			
			player.moveBy(0, -1);
			assertEqual(player.position.x, 5);
			assertEqual(player.position.y, 5);
		}
		
		private function assertEqual(actual:Object, expected:Object):void
		{
			if (expected == actual)
				return;
			
			message = "Expected " + expected + " but got " + actual + ".";
			trace(message);
			passed = false;
		}
	}
}