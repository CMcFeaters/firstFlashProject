package players 
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author cmcfeaters
	 */
	public class Player extends Sprite
	{
		[Embed(source = "../pics/Hero.png")]
		public static const GfxHero:Class;
		private var gfx:Bitmap;
		public var chasing:int;
		public var distToEnemy:Array;
		public var heroNum:int;
		public var canKill:Boolean;
		
		public function Player() 
		{
			trace("I shall smite you");
			gfx = new Player.GfxHero();
			gfx.scaleX = .3;
			gfx.scaleY = .3;
			addChild(gfx);
			
			distToEnemy = [];
			chasing = -1;
			heroNum = -1;	//set by main when created
			canKill = false;
			addEventListener(MouseEvent.CLICK, handleClick);
		}
		
		private function handleClick(e:MouseEvent):void {
			
			trace("I am hero: " + heroNum);
			trace("I am chasing enemy: " + chasing);
			trace("My distance to enemy is: " + distToEnemy);
		}
		
		private function distToEnemies(eArr:Array):void {
			//detects the distance to enemies
			//fills distToEnemy Array
			distToEnemy = [];
			for (var i:int = 0; i < eArr.length; i++) {
				distToEnemy[i] = distance(eArr[i].x, eArr[i].y);//build an array of distances to enemies
			}
		}
		
		public function findTarget(eArr:Array, hArr:Array):void {
			//finds the closest enemy to the hero
			//that enemy must not be being chased by another hero who is closer
			//if it is, find teh next closest enemy, check against other heroes
			//repeat until target found
			//if numtargets < numheroes, chase the closest
			distToEnemies(eArr);	//fill the array
			var tFound:Boolean = false;
			var minDex:int;
			while (tFound==false) {
				minDex = findMin(distToEnemy);
				if (checkHeroes(hArr, minDex, distToEnemy[minDex]) == true || hArr.length>eArr.length) {//the enemy we wanted is good to go
					trace("(" + minDex + "," + distToEnemy[minDex] + ")");
					chasing = minDex;
					if (distToEnemy[minDex] < 25) {//we are close enough to kill
						canKill = true;
					}else { canKill = false; }
					tFound = true;
				}else{//the enemy we want is already taken
					distToEnemy[minDex] = 5000;
				}
			}
		}
		
		private function findMin(arr:Array):int {
			//returns the index of the minimum value of an array
			var ind:int;
			var val:int = 5000;
			for (var i:int = 0; i < arr.length; i++) {
				if (arr[i] < val) {
					val = arr[i];
					ind = i;
				}
			}
			return ind;
		}
		
		private function checkHeroes(hArr:Array,eNum:int,eDist:int):Boolean {
			//checks the current potential enemy against the enemies the other heroes are chasing
			for (var i:int = 0; i < hArr.length; i++) {
				if (i != this.heroNum) {
					if (eNum == hArr[i].chasing) {//is another hero chasing this enemy?
						if( eDist >= hArr[i].distToEnemy[hArr[i].chasing]) {//is he closer?
							return false;
						}
					}
				}
			}
			return true;	//we are good to chase this enemy
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