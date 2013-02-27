package enemies 
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import Math;
	
	/**
	 * ...
	 * @author cmcfeaters
	 */
	public class Enemy extends Sprite
	{
		//THESE ARE ALL PARTS OF THE ENEMY CLASS
		[Embed(source = "../pics/gardengnome.png") ]//attached to GfxGnome class now
		private static const GfxGnome:Class;	//static designates this property attached to the class and any instances created 
		private var gfx:Bitmap;
		public var runningFrom:int;
		public var spawnNum:int;
		public var distToHero:int;
		public var enemyNumber:int;
		
		public function Enemy() 
		{
			trace("I'm ALIVE!");
			gfx = new Enemy.GfxGnome;
			addChild(gfx);
			
			runningFrom= -1;
			spawnNum = Math.round(Math.random() * 100);
			distToHero = -1;
			enemyNumber = -1;
			addEventListener(MouseEvent.CLICK, handleClick);
			
		}
		
		public function handleClick(e:MouseEvent):void
		{
			trace ("I am enemy: " + enemyNumber);
			trace("I am running from hero: " + runningFrom);
			trace("Distance to Hero is: " + distToHero);
			trace("My spawn Number is: " + spawnNum);
		}
		
		public function detectClosest(hArr:Array):void{
			//this function cycles through all hero class positions and determines which one is closest to it
			var tempDist:int;
			for (var i:int = 0; i < hArr.length; i++) {
				tempDist = distance(hArr[i].x, hArr[i].y);
				//compare distances
				//trace ("Hero: " + i + " Distance: " + tempDist);
				if (tempDist < distToHero || distToHero==-1) {
					distToHero = tempDist;
					runningFrom = i;
				}
				
			}
		}
		
		private function distance(x:int, y:int):int {
			//compute the distance between two points
			var dist:int;
			var rise:int = y - this.y;
			var run:int = x - this.x;
			//trace ("rise: " + rise + " , run: " + run);
			dist = Math.sqrt(Math.pow(run,2) + Math.pow(rise,2));
			return dist
		}
		
	}
	
}