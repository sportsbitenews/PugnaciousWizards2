package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import knave.BaseScreen;
	
	public class TargetDirectionScreen extends BaseScreen
	{
		public function TargetDirectionScreen(player:Creature, callback:Function) 
		{
			bind('left', function():void { callback(player, -1, 0); exit(); } );
			bind('right', function():void { callback(player, 1, 0); exit(); } );
			bind('up', function():void { callback(player, 0, -1); exit(); } );
			bind('down', function():void { callback(player, 0, 1); exit(); } );
			bind('up left', function():void { callback(player, -1, -1); exit(); } );
			bind('up right', function():void { callback(player, 1, -1); exit(); } );
			bind('down left', function():void { callback(player, -1, 1); exit(); } );
			bind('down right', function():void { callback(player, 1, 1); exit(); } );
			bind('wait', function():void { callback(player, 0, 0); exit(); } );
			bind('escape', function():void { exit(); } );
			bind('draw', draw);
		}
		
		public function draw(terminal:AsciiPanel):void 
		{
			terminal.write("Which direction? (use movement keys)", 2, 78, 0xffffff);
		}
	}
}