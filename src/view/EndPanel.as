package view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import flashx.textLayout.accessibility.TextAccImpl;
	
	import model.Global;
	
	import util.HttpRequest;
	
	public class EndPanel extends Sprite
	{
		private var _bg:Sprite = new Sprite();
		private var _endTf:TextField = new TextField();
		private var _reGameBtn:Sprite = new Sprite();
		private var _reGameBtnTf:TextField = new TextField();
		private var _namePutTf:TextField = new TextField();
		private var _namePutLable:TextField = new TextField();
		private var _namePutBtn:Sprite = new Sprite();
		
		private static var _instance:EndPanel;
		
		private var endTextPool:Array =
			[
				"啊，看来这把运气不佳~",
				"因为太贪吃，蛇死了~",
				"看来还是不能贪图无厌啊~"
			];
		
		public static function get instance():EndPanel
		{
			if(!_instance)
			{
				_instance = new EndPanel();
			}
			return _instance;
		}
		
		public function EndPanel()
		{
			setBg();
			addChild(_bg);		
			addEventListener(Event.ADDED_TO_STAGE,init);
			addEventListener(Event.REMOVED_FROM_STAGE,dispose);
		}
		
		private function setBg():void
		{
			_bg.graphics.beginFill(0x012345);
			_bg.graphics.drawRoundRect(0,0,200,200,20);
			_bg.graphics.endFill();
			
			_endTf.mouseEnabled = false;
			_endTf.x = (_bg.width - _endTf.width)/2;
			_endTf.y = 10;
			_endTf.textColor = 0x000000;
			_bg.addChild(_endTf);
			
			_namePutTf.background = true;
			_namePutTf.border = true;
			_namePutTf.x = (_bg.width - _namePutTf.width)/2;
			_namePutTf.y = _endTf.y +30;
			_namePutTf.height = 17;
			_namePutTf.type = TextFieldType.INPUT;
			_namePutTf.text = "输入你的名字吧";
			_bg.addChild(_namePutTf);
			
			_namePutBtn.buttonMode = true;
			_namePutBtn.graphics.beginFill(0x654321);
			_namePutBtn.graphics.drawRoundRect(0,0,20,20,5);
			_namePutBtn.graphics.endFill();
			_namePutBtn.width = 80;
			_namePutBtn.x = (_bg.width - _namePutBtn.width)/2;
			_namePutBtn.y = (_namePutTf.y + 20);
			_bg.addChild(_namePutBtn);
			
			_namePutLable.mouseEnabled = false;
			_namePutLable.text = "输入完毕";
			_namePutBtn.addChild(_namePutLable);
			_namePutBtn.addEventListener(MouseEvent.CLICK, onNamePutComp);
		}
		
		private function onNamePutComp(evt:MouseEvent):void
		{
			EndPanel._instance.visible = false;
			Global.started = false;
			
			var name:String = _namePutTf.text;
			
			HttpRequest.instance.call('updateScore',{'name':name,'score': Global.score,'time':Global.timer});
			Global.reset();
		}
		
		private function init(evt:Event):void
		{
			setEndText();
		}
		
		private function dispose(evt:Event):void
		{
			
		}
		
		private function setEndText():void
		{
			var lucky:int = Math.floor((Math.random()*endTextPool.length));
			_endTf.text = endTextPool[lucky];
		}
		
	}
}