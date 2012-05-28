package control
{
	import flash.events.Event;
	
	import model.Direct;
	import model.Global;
	
	import view.Bg;

	public class GameControler
	{
		private static var _instance:GameControler;
		
		public function GameControler()
		{
		}
		
		public static function get instance():GameControler
		{
			if(!_instance)
			{
				_instance = new GameControler();
			}
			return _instance;
		}
		
		private function countTime(evt:Event):void
		{
			Global.timer++;
		}
		
		public function startTimeCount():void
		{
			Global.timer = 0;
			TimeControler.instance.addEventListener(TimeControler.TICK,countTime);
		}
		
		
		public function resumeTimeCount():void
		{
			TimeControler.instance.addEventListener(TimeControler.TICK,countTime);
		}
		
		public function pauseTimeCount():void
		{
			TimeControler.instance.removeEventListener(TimeControler.TICK,countTime);
		}
		
		public function startGame():void
		{
			if(!Global.started && !Global.lived)
			{
				Global.started = true;
				Global.lived = true;
				Bg.instance.makeSnakeHead();
				Bg.instance.generateFood();
				initMove();
				startTimeCount();
			}
		}
		
		public function pauseGame():void
		{	
			if(Global.started && Global.lived && !Global.paused)
			{
				Global.paused  = true;
				stopAllMove();
				pauseTimeCount();
			}
		}
		
		public function resumeGame():void
		{	
			if(Global.started && Global.lived && Global.paused)
			{
				Global.paused = false;
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveLeft);
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveUp);
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveRight);
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveDown);
				switch(Global.direction)
				{
					case Direct.LEFT:
						TimeControler.instance.addEventListener(TimeControler.MOVE, moveLeft);
						break;
					case Direct.RIGHT:
						TimeControler.instance.addEventListener(TimeControler.MOVE, moveRight);
						break;
					case Direct.UP:
						TimeControler.instance.addEventListener(TimeControler.MOVE, moveUp);
						break;
					case Direct.DOWN:
						TimeControler.instance.addEventListener(TimeControler.MOVE, moveDown);
						break;
				}
				resumeTimeCount();
			}
		}
		
		public function restartGame():void
		{	
		}
		
		public function stopAllMove():void
		{
			TimeControler.instance.removeEventListener(TimeControler.MOVE, moveLeft);
			TimeControler.instance.removeEventListener(TimeControler.MOVE, moveUp);
			TimeControler.instance.removeEventListener(TimeControler.MOVE, moveRight);
			TimeControler.instance.removeEventListener(TimeControler.MOVE, moveDown);
		}
		
		private function initMove():void
		{
			TimeControler.instance.addEventListener(TimeControler.MOVE, moveLeft);
			TimeControler.instance.removeEventListener(TimeControler.MOVE, moveUp);
			TimeControler.instance.removeEventListener(TimeControler.MOVE, moveRight);
			TimeControler.instance.removeEventListener(TimeControler.MOVE, moveDown);
		}
		
		public function turnLeft():void
		{
			trace("i wanna moving left");
			traceDirection();
			if(Global.lived && Global.direction != Direct.LEFT && Global.direction != Direct.RIGHT)
			{
				TimeControler.instance.addEventListener(TimeControler.MOVE, moveLeft);
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveUp);
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveRight);
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveDown);
			}
		}
		
		public function turnUp():void
		{
//			trace("i wanna moving up");
			traceDirection();
			if(Global.lived && Global.direction != Direct.UP && Global.direction != Direct.DOWN)
			{
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveLeft);
				TimeControler.instance.addEventListener(TimeControler.MOVE, moveUp);
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveRight);
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveDown);
			}
		}
		
		public function turnDown():void
		{
//			trace("i wanna moving down");
			traceDirection();
			if(Global.lived && Global.direction != Direct.UP && Global.direction != Direct.DOWN)
			{
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveLeft);
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveUp);
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveRight);
				TimeControler.instance.addEventListener(TimeControler.MOVE, moveDown);
			}
		}
		
		public function turnRight():void
		{
//			trace("i wanna moving right");
			traceDirection();
			if(Global.lived && Global.direction != Direct.LEFT && Global.direction != Direct.RIGHT)
			{
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveLeft);
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveUp);
				TimeControler.instance.addEventListener(TimeControler.MOVE, moveRight);
				TimeControler.instance.removeEventListener(TimeControler.MOVE, moveDown);
			}
		}
		
		private function traceDirection():void
		{
//			trace("now direction is "+Global.direction);
		}
		
		private function move(direction:String):void
		{
			if(Direct.isDirection(direction))
			{
				Global.direction = direction;
//				trace("i am moving "+direction);
				Global.moveLock = true;
				Bg.instance.move();
				switch(direction)
				{
					case Direct.LEFT:
						Bg.instance.headLeft();
						break;
					case Direct.RIGHT:
						Bg.instance.headRight();
						break;
					case Direct.UP:
						Bg.instance.headUp();
						break;
					case Direct.DOWN:
						Bg.instance.headDown();
						break;
				}
				Bg.instance.eat();
				Bg.instance.die();
				Global.moveLock = false;
			}
		}
		
		private function moveLeft(evt:Event):void
		{
			if(!Global.moveLock)
			{
				move(Direct.LEFT);
			}
		}
		
		private function moveRight(evt:Event):void
		{
			if(!Global.moveLock)
			{
				move(Direct.RIGHT);
			}
		}
		
		private function moveUp(evt:Event):void
		{
			if(!Global.moveLock)
			{
				move(Direct.UP);
			}
		}
		
		private function moveDown(evt:Event):void
		{
			if(!Global.moveLock)
			{
				move(Direct.DOWN);
			}
		}
		
	}
}