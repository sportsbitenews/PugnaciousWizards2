package screens 
{
	import com.headchant.asciipanel.AsciiPanel;
	import knave.BaseScreen;
	import knave.Color;
	import knave.RL;
	import knave.Text;
	import spells.Spell;
	
	public class SpellShopScreen extends BaseScreen
	{
		private var w:int = 0;
		private var h:int = 0;
		private var background:int = Color.integer(0x101020).toInt();
		private var text:Array;
		private var spellList:Array;
		private var player:Creature;
		private var failedToBuy:Boolean = false;
		private var cost:int;
		
		public function SpellShopScreen(player:Creature, spellList:Array) 
		{
			this.player = player;
			this.spellList = spellList;
			this.cost = CurrentGameVariables.storeCost;
			
			w = 80;
			text = [];
			text.push(Text.padToCenter(w, "-- Spell shop --"));
			text.push("");
			text.push("Spend extra gold to gain new spells. Each spell cost $" + cost + ".");
			text.push("");
			var i:int = 0;
			for each (var spell:Spell in spellList)
			{
				i++;
				text.push(" " + i + " " + spell.name);
				addSpell(spell.description, text);
				text.push("");
				bind('' + i, buy, i - 1); 
			}
			while (text.length < 15)
				text.push("");
				
			text.push(Text.padToCenter(w, "-- press escape to cancel --"));
			text.push(Text.padToCenter(w, "-- press 1 through " + i + " to buy a spell --"));
			
			h = this.text.length * 2 + 3;
			
			bind('escape', 'exit');
			bind('enter', 'exit')
			bind('exit', function():void { exit(); } );
			bind('draw', draw);
		}
		
		private function addSpell(fullText:String, text:Array):void
		{
			for each (var line:String in Text.wordWrap(w, fullText))
				text.push("   " + line);
		}
		
		private function buy(index:int):void
		{
			failedToBuy = player.gold < cost;
				
			if (failedToBuy)
				return;
			
			var spell:Spell = spellList[index];
			player.addMagicSpell(spell);
			spellList.splice(index, 1);
			player.gold -= cost;
			exit();
		}
		
		private function draw(terminal:AsciiPanel):void
		{
			var left:int = (terminal.getWidthInCharacters() - w) / 2 - 2;
			var top:int = (terminal.getHeightInCharacters() - h) / 2;
			
			for (var x:int = 0; x < w + 4; x++)
			for (var y:int = 0; y < h; y++)
				terminal.write(" ", left + x, top + y, null, background);
			
			for (var i:int = 0; i < text.length; i++)
			{
				for (x = 0; x < text[i].length; x++)
				{
					y = i * 2
					terminal.write(text[i].charAt(x), left + x + 2, top + y + 2, 0xffffff, background);
				}
			}
			
			if (failedToBuy)
				terminal.write("You need at least $" + cost + " to buy a spell.", left + 2, top + y + 6, 0xffffff);
		}
	}
}