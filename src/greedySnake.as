package
{
	import control.GameControler;
	import control.TimeControler;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import model.Global;
	
	import org.osmf.net.dynamicstreaming.INetStreamMetrics;
	
	import util.XMLReader;
	
	import view.Bg;
	import view.ControlPanel;
	import view.EndPanel;
	import view.StausPanel;
	
	public class greedySnake extends Sprite
	{
		private var _pool:Sprite = new Sprite();
		private var _stPanel:StausPanel = StausPanel.instance;
		private var _endPanel:EndPanel = new EndPanel();
		private var _ctrlPanel:ControlPanel = new ControlPanel();
		private var _bg:Bg = Bg.instance;
		
		private var _xmlIndex:int = 0;
		private const XML_CONDIG:Array = ["diff"];
		private const FILE_HEAD:String = "config/";
		private const EXT_NAME:String = ".xml";
		
		public function greedySnake()
		{
			loadConfig();
		}
		
		private function loadConfig():void
		{
			if(_xmlIndex < XML_CONDIG.length)
			{
				var name:String = XML_CONDIG[_xmlIndex];
				var urlLoader:URLLoader = new URLLoader();
				var request:URLRequest = new URLRequest(FILE_HEAD+name+EXT_NAME);
				urlLoader.load(request);
				urlLoader.addEventListener(Event.COMPLETE,function(evt:Event):void
				{
					XMLReader.instance.addXMLByName(name,new XML(evt.currentTarget.data));
					_xmlIndex++;
					loadConfig();
				});
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR,function(evt:IOErrorEvent):void
				{
					trace(evt.text);
				});
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function(evt:SecurityErrorEvent):void
				{
					trace(evt.text);
				});
			}
			else
			{
				initGame();
			}
		}
		
		private function initGame():void
		{
			addChild(_bg);
			_stPanel.x = _bg.x;
			_stPanel.y = _bg.y+_bg.height;
			addChild(_stPanel);
			_ctrlPanel.x = _bg.x+Global.POOL_WIDTH;
			_ctrlPanel.y = _bg.y;
			addChild(_ctrlPanel);
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			TimeControler.instance.start();
		}
		
		private function onKeyDown(evt:KeyboardEvent):void
		{
			switch(evt.keyCode)
			{
				//ENTER
				case 0xD:
					GameControler.instance.startGame();
					break;
				//ESC
				case 27:
					GameControler.instance.pauseGame();
					break;
				//SPACE
				case 0x20:
					GameControler.instance.resumeGame();
					break;
				//LEFT
				case 0x25:
					GameControler.instance.turnLeft();
					break;
				//UP
				case 0x26:
					GameControler.instance.turnUp();
					break;
				//RIGHT
				case 0x27:
					GameControler.instance.turnRight();
					break;
				//DOWN
				case 0x28:
					GameControler.instance.turnDown();
					break;
			}
		}	
	}
}