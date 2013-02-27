package 
{
	import enemies.Enemy;
	import flash.display.DisplayObject;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import Math;
	import players.Player;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author cmcfeaters
	 * X) get heros and enemies on screen
	 * X) have enemies move away from closest hero
	 * 	 X-enemies need to detect which hero is closest
	 * 	 -then move away from hero
	 * X) have heros detect which enemy is closest
	 * X) move toward that enemy
	 * X) enemy spawn ability
	 * 6) hero kill/spawn/infected ability
	 * 7) determine # heroe's/number enemies
	 * 
	 */
	public class Main extends Sprite 
	{
		private var eArr:Array = [];
		private var hArr:Array = [];
		private var runstop:Boolean;
		private var heroEnemy:Boolean;
		public function Main():void 
		{
			trace("Hello World");
			createHero();
			createEnemy();
			runstop = false;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, startstop);
			stage.addEventListener(MouseEvent.CLICK, spawnThing);
			stage.addEventListener(Event.ENTER_FRAME, theShow);
		}
		
		private function theShow(e:Event):void {
			if (runstop) {
				//trace("Heroes: " + hArr.length + " Enemies: " + eArr.length);
				if (hArr.length == 0) {//end game scenario
					runstop = false;
					trace("Enemies win");
				}else if (eArr.length == 0) {//endgame scenario
					runstop = false;
					trace("Heroes win");
				}else{
					updateEnemies();
					updateHeroes();
					moveEnemies();
					moveHeroes();
					spawnCheck(Math.round(Math.random() * 100))
					killCheck();
				}
			}
		}
		
		private function killCheck():void {
			//determines if any of the heroes kill an enemy
			//check to see if any hero is within kill range of his target
			//if so, roll to kill
			for (var i:int = 0; i < hArr.length; i++) {
				if (hArr[i].canKill && hArr[i].chasing<eArr.length) {//there is a hero that can try for a kill, let him begin 
					var roll:int = Math.round(Math.random() * 10);//used for killing
					
					if (roll <= 6) {//kill success
						//trace ("Hero " + i + " killed enemy " + hArr[i].chasing);
						removeChild(eArr[hArr[i].chasing]);
						eArr = deleteFromArray(hArr[i].chasing, eArr);
						hArr[i].chasing = -1;
						//trace("Length of enemy array: " + eArr.length);
					
					}else if (roll>6 && roll<=8) {//kill success, hero spawned
						removeChild(eArr[hArr[i].chasing]);
						eArr=deleteFromArray(hArr[i].chasing, eArr);
						createHero();
					
					}else {//failure, hero killed, enemy spawned
						removeChild(hArr[i])
						hArr=deleteFromArray(i, hArr);
					}
				}else if (hArr[i].chasing >= eArr.length) { hArr[i].chasing = -1;}
			}
		}
		
		private function spawnCheck(spawnNum:int):void {
			//checks/spawns enemies as needed
			for each (var en:Enemy in eArr) {
				if (spawnNum == en.spawnNum) {
					createEnemy();
				}
			}
		}
		
		private function deleteFromArray(i:int,arr:Array):Array {
			//removes hero i from the hArr and the stage
			var tArr:Array = [];
			var count:int = 0;
			for (var j:int = 0; j < arr.length; j++) {//create a new array without the old child
				if (j != i) {
					tArr[count] = arr[j];
					count += 1;
				}
			}
			return tArr;
		}
		
		private function spawnThing(e:MouseEvent):void {
			//spawn a new enemy wherever the mouse was clicked
			if (heroEnemy){//spawn a hero
				var i:int = hArr.length;
				hArr[i] = new Player();
				hArr[i].x = mouseX;
				hArr[i].y = mouseY;
				hArr[i].heroNum = i;
				addChild(hArr[i]);
			}else {//spawn an enemy
				var i:int = eArr.length;
				eArr[i] = new Enemy();
				eArr[i].x = mouseX;
				eArr[i].y = mouseY;
				eArr[i].enemyNumber = i;
				addChild(eArr[i]);
			}
		}
		
		private function startstop(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.SPACE) {//starts stops events
				runstop = !runstop;
				trace("Running: " + runstop);
			}else if (e.keyCode == Keyboard.A) {//alternates between heroes and enemies for mouse click
				heroEnemy = !heroEnemy;
				if (heroEnemy) {//say what's going on
					trace("Making Heroes");
				}else{trace("making Enemies")}
				
			}
		}
		
		private function createEnemy():void{
			var i:int = eArr.length;
			eArr[i] = new Enemy();
			eArr[i].x = 500+ Math.random() * 417;
			eArr[i].y =  100+Math.random() * 517;
			eArr[i].enemyNumber = i;
			addChild(eArr[i]);
			trace("Enemy BORN at (" + eArr[i].x + "," + eArr[i].y + ")");
		}
		
		private function createHero():void {
			var i:int = hArr.length;
			hArr[i] = new Player();
			hArr[i].x =  Math.random() * 200;
			hArr[i].y =  Math.random() * 624;
			hArr[i].heroNum = i;
			addChild(hArr[i]);
			trace("HERO BORN at (" + hArr[i].x + "," + hArr[i].y + ")");
		}
		
		public function updateEnemies():void {
			for each ( var thing:Enemy in eArr) {
				thing.detectClosest(hArr);
			}
		}
		
		public function updateHeroes():void {
			for each(var thing:Player in hArr) {
				thing.findTarget(eArr, hArr);
			}
		}
		
		private function moveEnemies():void {
			//for each enemy on screen move them away from the hero they are running from
			//should add some randomness to movement 
			for each (var en:Enemy in eArr) {
				if (en.runningFrom<hArr.length) {
					if (en.x < hArr[en.runningFrom].x  && en.x > 50) {	//handle the x plain
						en.x -= 1;
					}else if (en.x  > hArr[en.runningFrom].x  && en.x < 900) {
						en.x += 1;
					}

					if (en.y  < hArr[en.runningFrom].y && en.y > 50) {//y plain
						en.y -= 1;
					}else if (en.y  > hArr[en.runningFrom].y  && en.y < 600) {
						en.y += 1;
					}
				}
			}
		}
		
		private function moveHeroes():void {
			//for each enemy on screen move them away from the hero they are running from
			//should add some randomness to movement 
			//THIS COULD GO IN THE HERO CLASS
			for each (var he:Player in hArr) {
				if (he.chasing < eArr.length) {
					//trace(he);
					if (he.x > eArr[he.chasing].x  && he.x > 50) {	//handle the x plain
						he.x -= 5;
					}else if (he.x  < eArr[he.chasing].x  && he.x < 950) {
						he.x += 5;
					}
				
					if (he.y  > eArr[he.chasing].y  && he.y > 50) {//y plain
						he.y -= 5;
					}else if (he.y  < eArr[he.chasing].y  && he.y < 650) {
						he.y += 5;
					}
				}else {
					updateHeroes();
				}
			}
		}

		
		
		
		private function mouseHandler(e:MouseEvent):void	//this even is handled when the frame is entered?
		{
			//var rot = Math.atan2(mouseY-enemy.y,mouseX-enemy.x) * 180 / Math.PI;
			//enemy.rotationZ = rot;
			var tEnemy:Enemy = e.target as Enemy;
			//get my position
			if (tEnemy.x+41 < mouseX  && tEnemy.x>76){
				tEnemy.x -= 1;
			}else if (tEnemy.x+41 > mouseX && tEnemy.x<924){
				tEnemy.x += 1;
			}
			
			if (tEnemy.y+41 < mouseY  && tEnemy.y>76){
				tEnemy.y -= 1;
			}else if (tEnemy.y+41 > mouseY && tEnemy.y<624){
				tEnemy.y += 1;
			}
			
			//determine if i need to move towards away or not at all in x
			//determine if i need to move towards, away or not at all in y
			
		}
		
	}
	
}