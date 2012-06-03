package view
{
	import control.GameControler;
	import control.ModeControler;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.FileReference;
	
	import model.Global;
	import model.KnotType;
	
	import util.XMLReader;
	
	import view.knot.Knot;
	import view.knot.RoundRectKnot;

	public class Bg extends Sprite
	{
		private static var _instance:Bg;
		
		private var _pool:Sprite = new Sprite();
		private var _food:Sprite = new Sprite();
		private var _head:Sprite = new Sprite();
		private var _grid:Sprite = new Sprite();
		private var _obst:Sprite = new Sprite();
		private var _clear:Sprite = new Sprite();
		private var _outPutBtn:Sprite = new Sprite();
		private var _initPos:Sprite = new Sprite();
		
		private var _moveObst:Sprite;
		
		private var _snake:Array = [];
		private var _obstacles:Array = [];
		private var _mapings:Array = [];
		
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
				_instance.drawGrid();
				_instance.initMapingSence();
				_instance.showMapingTool(false);
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
				GameControler.instance.pauseTimeCount();
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
		
		private function drawGrid():void
		{
			_grid.graphics.clear();
//			_grid.graphics.beginFill(Global.COLOR_GRID);
			_grid.graphics.lineStyle(1,Global.COLOR_GRID);
			for(var i:int = 0;i<=_pool.width;i+=Global.OBSTACLE_LENGTH)
			{
				_grid.graphics.moveTo(i,0);
				_grid.graphics.lineTo(i,_pool.height);
			}
			for(var j:int = 0;j<=_pool.height;j+=Global.OBSTACLE_LENGTH)
			{
				_grid.graphics.moveTo(0,j);
				_grid.graphics.lineTo(_pool.width,j);
			}
			_grid.graphics.endFill();
			_pool.addChild(_grid);
		}
		
		public function clearSnakeFoodObst():void
		{
			for each(var knot:Sprite in _snake)
			{
				if(knot.parent)
				{
					knot.parent.removeChild(knot);
				}
			}
			_snake = [];
			for each(var obst:Sprite in _obstacles)
			{
				if(obst.parent)
				{
					obst.parent.removeChild(obst);
				}
			}
			_obstacles = [];
			if(_food && _food.parent)
			{
				_food.parent.removeChild(_food);
			}
		}
		
		private function initMapingSence():void
		{
			_clear = new RoundRectKnot(Global.OBSTACLE_LENGTH,Global.OBSTACLE_LENGTH,5,KnotType.NOTHING,0xEEEEEE);
			_clear.buttonMode = true;
			_clear.x = _pool.x+_pool.width+10;
			_clear.y = _pool.y+20;
			addChild(_clear);
			_clear.addEventListener(MouseEvent.CLICK,changeToClearMode);
			
			_obst = new RoundRectKnot(Global.OBSTACLE_LENGTH,Global.OBSTACLE_LENGTH,5,KnotType.NOTHING,Global.COLOR_OBSTACLE);
			_obst.buttonMode = true;
			_obst.x = _pool.x+_pool.width+10;
			_obst.y = _pool.y+50;
			addChild(_obst);
			_obst.addEventListener(MouseEvent.CLICK,genObst);
			
			_outPutBtn = new Sprite();
			_outPutBtn.buttonMode = true;
			_outPutBtn.graphics.beginFill(0x123456);
			_outPutBtn.graphics.drawCircle(0,0,10);
			_outPutBtn.graphics.endFill();
			_outPutBtn.x = _pool.x+_pool.width+10;
			_outPutBtn.y = _pool.y+100;
			addChild(_outPutBtn);
			_outPutBtn.addEventListener(MouseEvent.CLICK,outPutMap);
			
			_initPos = new RoundRectKnot(Global.SNAKE_KNOT_LENGTH,Global.SNAKE_KNOT_LENGTH,Global.SNAKE_KNOT_LENGTH,KnotType.NOTHING,Global.COLOR_SNAKE);
			_initPos.x = Global.POOL_WIDTH/2;
			_initPos.y = Global.POOL_HEIGHT/2;
			_pool.addChild(_initPos);
		}
		
		private function changeToClearMode(evt:MouseEvent):void
		{
			ModeControler.instance.changeMode(Global.MODE_CLEAR);
			if(_moveObst)
			{
				_moveObst.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
				_moveObst.removeEventListener(MouseEvent.CLICK,stackHere);
				_moveObst.removeEventListener(MouseEvent.CLICK,editObst);
				if(_moveObst.parent)
				{
					_moveObst.parent.removeChild(_moveObst);
				}
				_moveObst = null;
			}
			for each(var obst:Sprite in _mapings)
			{
				obst.removeEventListener(MouseEvent.CLICK,stackHere);
			}
		}
		
		public function showMapingTool(showOrNot:Boolean):void
		{
			_grid.visible = showOrNot;
			_obst.visible = showOrNot;
			_outPutBtn.visible = showOrNot;
			_mapings = [];
			_initPos.visible = showOrNot;
			_clear.visible = showOrNot;
		}
		
		private function genObst(evt:MouseEvent):void
		{
			var obst:Sprite = new RoundRectKnot(Global.OBSTACLE_LENGTH,Global.OBSTACLE_LENGTH,5,KnotType.OBSTACLE,Global.COLOR_OBSTACLE);
			obst.x = _pool.width+_pool.x+5;
			obst.y = 50;
			_pool.addChild(obst);

			_moveObst = obst;
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		
		private function onMouseMove(evt:MouseEvent):void
		{
			if(_moveObst && _moveObst.parent)
			{
				_moveObst.x = _moveObst.parent.globalToLocal(new Point(evt.stageX,evt.stageY)).x-(Global.OBSTACLE_LENGTH/2);
				_moveObst.y = _moveObst.parent.globalToLocal(new Point(evt.stageX,evt.stageY)).y-(Global.OBSTACLE_LENGTH/2);
				
				_moveObst.addEventListener(MouseEvent.CLICK,stackHere);
			}
		}
		
		private function stackHere(evt:MouseEvent):void
		{
			var obst:Sprite = (evt.currentTarget as Sprite);
			if(obst.x < 0 || obst.x>=_pool.width || obst.y < 0 || obst.y >= _pool.height)
			{
				return;
			}
			obst.x = Math.round(obst.x/Global.OBSTACLE_LENGTH)*Global.OBSTACLE_LENGTH;
			obst.y = Math.round(obst.y/Global.OBSTACLE_LENGTH)*Global.OBSTACLE_LENGTH;
			if(_mapings.indexOf(obst) >= 0)
			{
				_mapings.splice(_mapings.indexOf(obst),1);
			}
			_mapings.push(obst);
			obst.addEventListener(MouseEvent.CLICK,editObst);
			_moveObst = null;
			
			var newobst:Sprite = new RoundRectKnot(Global.OBSTACLE_LENGTH,Global.OBSTACLE_LENGTH,5,KnotType.OBSTACLE,Global.COLOR_OBSTACLE);
			newobst.x = obst.x;
			newobst.y = obst.y;
			_pool.addChild(newobst);
			_moveObst = newobst;
		}
		
		private function editObst(evt:MouseEvent):void
		{
			switch(Global.mode)
			{
				case Global.MODE_CLEAR:
					if(evt.currentTarget.parent)
					{
						evt.currentTarget.parent.removeChild(evt.currentTarget);
					}
					if(_mapings.indexOf(evt.currentTarget)>=0)
					{
						_mapings.splice(_mapings.indexOf(evt.currentTarget),1);
					}
					break;
				case Global.MODE_MAPING:
					break;
			}
		}
		
		private function outPutMap(evt:MouseEvent):void
		{
			if(_mapings && _mapings.length)
			{
				var mapXML:XML = new XML();
				mapXML = <map id="x"></map>;
				for each(var obst:Sprite in _mapings)
				{
					mapXML.appendChild(<obst x={obst.x} y={obst.y} />);
				}
				var fr:FileReference = new FileReference();
				fr.save(mapXML,"map.xml");
			}
		}
		
		public function inputMap(mapid:int):void
		{
			var mapConf:XML = XMLReader.instance.getXMLByName("map");
			var mapList:XMLList = mapConf.child("map");
			var obstList:XMLList;
			var obstKnot:RoundRectKnot;
			
			for each(var obst:RoundRectKnot in _obstacles)
			{
				if(obst.parent)
				{
					obst.parent.removeChild(obst);
				}
			}
			_obstacles = [];
			
			for each(var map:XML in mapList)
			{
				if( int(map.@id) == mapid)
				{
					obstList = map.child("obst");
					for each(var obstPos:XML in obstList)
					{
						obstKnot = new RoundRectKnot(Global.OBSTACLE_LENGTH, Global.OBSTACLE_LENGTH, Global.OBSTACLE_ELIIPSE,KnotType.OBSTACLE,Global.COLOR_OBSTACLE);
						obstKnot.x = int(obstPos.@x);
						obstKnot.y = int(obstPos.@y);
						_pool.addChild(obstKnot);
						_obstacles.push(obstKnot);
					}
				}
			}
			
		}
		
		public function clearAllMaping():void
		{
			for each(var obst:Sprite in _mapings)
			{
				if(obst.parent)
				{
					obst.parent.removeChild(obst);
				}
				obst.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
				obst.removeEventListener(MouseEvent.CLICK,stackHere);
				obst.removeEventListener(MouseEvent.CLICK,editObst);
			}
			_mapings = [];
		}
		
	}
}