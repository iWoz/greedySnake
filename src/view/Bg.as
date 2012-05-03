package view
{
	import control.GameControler;
	
	import flash.display.Sprite;
	
	import model.Global;
	import model.KnotType;
	
	import view.knot.RoundRectKnot;

	public class Bg extends Sprite
	{
		private static var _instance:Bg;
		
		private var _pool:Sprite = new Sprite();
		private var _food:Sprite = new Sprite();
		private var _head:Sprite = new Sprite();
		private var _snake:Array = [];
		private var _obstacles:Array = [];
		
		public function Bg()
		{
		}
		
		public static function get instance():Bg
		{
			if(!_instance)
			{
				_instance = new Bg();
				_instance.drawPool();
				_instance.addChild(EndPanel.instance);
				EndPanel.instance.x = (_instance.width - EndPanel.instance.width)/2;
				EndPanel.instance.y = (_instance.height - EndPanel.instance.height)/2;
				EndPanel.instance.visible = false;
			}
			return _instance;
		}
		
		public function makeSnakeHead():void
		{
			_head = new RoundRectKnot(Global.SNAKE_KNOT_LENGTH,Global.SNAKE_KNOT_LENGTH,Global.SNAKE_KNOT_LENGTH,KnotType.SNAKE,Global.COLOR_SNAKE);
			_snake.push(_head);
			_head.x = Global.POOL_WIDTH/2;
			_head.y = Global.POOL_HEIGHT/2;
			_pool.addChild(_head);
		}
		
		public function generateFood():Sprite
		{
			_food = new RoundRectKnot(Global.FOOD_LENGTH,Global.FOOD_LENGTH,5,KnotType.FOOD,Global.COLOR_FOOD);
			var wNum:uint = 0;
			var hNum:uint = 0;
			var i:uint = 0;
			var j:uint = 0;
			var flag:Boolean = false;
			do{
				flag = false;
				wNum = Global.POOL_WIDTH/_snake[0].width - 1;
				hNum = Global.POOL_HEIGHT/_snake[0].height - 1;
				if(wNum>0) _food.x = Math.round(Math.random()*(wNum))*_snake[0].width;
				if(hNum>0) _food.y = Math.round(Math.random()*(hNum))*_snake[0].height;
				if(_food.x < 0 || _food.y <0 || _food.x >= Global.POOL_WIDTH || _food.y >= Global.POOL_WIDTH)
				{
					flag = true;
				}
				for(i = 0;i<_snake.length;i++)
				{
					if(_food.x==_snake[i].x && _food.y==_snake[i].y)
					{
						flag = true;
						break;
					}
				}
				for(j = 0;j<_obstacles.length;j++)
				{
					if(_food.x==_obstacles[j].x && _food.y==_obstacles[j].y)
					{
						flag = true;
						break;
					}
				}
			}while(flag==true);
			_pool.addChild(_food);
			return _food;
		}
		
		private function drawPool():void
		{
			_pool.x = 0;
			_pool.y = 0;
			_pool.graphics.beginFill(0x4682B4);
			_pool.graphics.drawRect(0,0,Global.POOL_WIDTH,Global.POOL_HEIGHT);
			_pool.graphics.endFill();
			if(_instance)
			{
				_instance.addChild(_pool);
			}
		}
		
		public function move():void
		{
			var i:uint;
			for(i = _snake.length-1;i>0;i--)
			{
				_snake[i].x = _snake[i-1].x;
				_snake[i].y = _snake[i-1].y;
			}
		}
		
		public function eat():void
		{
			if( _food && _snake[0].x == _food.x && _snake[0].y == _food.y)
			{
				Global.score += Global.speed;
				StausPanel.instance.updateScore(Global.score);
				if(this.stage.contains(_food))
				{
					_food.parent.removeChild(_food);
				}
				var knot:Sprite = new RoundRectKnot(Global.SNAKE_KNOT_LENGTH,Global.SNAKE_KNOT_LENGTH,5,KnotType.SNAKE,Global.COLOR_SNAKE);
				knot.x = -1000;
				knot.y = -1000;
				_snake.push(knot);
				_pool.addChild(knot);
				_pool.addChild(generateFood());
			}
		}
		
		public function die():void
		{
			var i:uint;
			/*蛇吃到自己*/
			for(i = 1;i<_snake.length;i++)
			{
				if(_snake[0].x==_snake[i].x && _snake[0].y==_snake[i].y)
				{
					Global.lived = false;
					break;
				}
			}
			/*蛇吃到障碍物*/
			for(i = 0;i<_obstacles.length;i++)
			{
				if(_snake[0].x==_obstacles[i].x && _snake[0].y==_obstacles[i].y)
				{
					Global.lived = false;
					break;
				}
			}
			if(Global.lived == false)
			{
				while(_snake.length)
				{
					_pool.removeChild(_snake.pop());
				}
				if(_food!=null && this.stage.contains(_food))
				{
					_food.parent.removeChild(_food);
				}
				GameControler.instance.stopAllMove();
				EndPanel.instance.visible = true;
			}
		}
		
		public function headLeft():void
		{
			if(_snake[0].x == 0)
			{
				_snake[0].x = Global.POOL_WIDTH - _snake[0].width;
			}
			else if(_snake[0].x <= Global.POOL_WIDTH-_snake[0].width && _snake[0].x > 0)
			{
				_snake[0].x -= _snake[0].width;
			}
		}
		
		public function headRight():void
		{
			if(_snake[0].x == Global.POOL_WIDTH - _snake[0].width)
			{
				_snake[0].x = 0;
			}
			else if(_snake[0].x < Global.POOL_WIDTH - _snake[0].width && _snake[0].x>=0)
			{
				_snake[0].x += _snake[0].width;
			}
		}
		
		public function headUp():void
		{
			if(_snake[0].y == 0)
			{
				_snake[0].y = Global.POOL_HEIGHT - _snake[0].height;
			}
			else if(_snake[0].y <= (Global.POOL_HEIGHT - _snake[0].height) && _snake[0].y >0)
			{
				_snake[0].y -= _snake[0].height;
			}

		}
		
		public function headDown():void
		{
			if(_snake[0].y == Global.POOL_HEIGHT - _snake[0].height)
			{
				_snake[0].y = 0;
			}
			else if(_snake[0].y < Global.POOL_HEIGHT - _snake[0].height && _snake[0].y >=0)
			{
				_snake[0].y += _snake[0].height;
			}
		}
	}
}