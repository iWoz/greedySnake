package view
{
	import control.GameControler;
	import control.TimeControler;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import model.Global;
	
	import util.HttpRequest;

	public class ControlPanel extends Sprite
	{
		private var _bg:Sprite = new Sprite();
		private var _introPanel:Sprite = new Sprite();
		private var _diffBtn:Sprite = new Sprite();
		private var _diffPanel:Sprite = new Sprite();
		private var _mapBtn:Sprite = new Sprite();
		private var _mapPanel:Sprite = new Sprite();
		private var _scoreBtn:Sprite = new Sprite();
		private var _scorePanel:Sprite = new Sprite();
		
		private var _diffButts:Array = [];
		private var _diffTexts:Array = [];
		
		private var _mapButts:Array = [];
		private var _mapTexts:Array = [];
		
		
		public function ControlPanel()
		{
			setIntroPanel();
			addChild(_introPanel);
			
			setBtn(_diffBtn,Global.COLOR_DIFF,"难度选择");
			_diffBtn.x = 5;
			_diffBtn.y = _introPanel.y + _introPanel.height;
			addChild(_diffBtn);
//			setDiffPanel();
			setChosePanel(_diffPanel, Global.COLOR_DIFF, Global.DIFF_NUM, _diffButts, _diffTexts);
			_diffPanel.x = _diffBtn.x+_diffBtn.width+5;
			_diffPanel.y = _diffBtn.y;
			addChild(_diffPanel);
			_diffPanel.visible = false;
			
			setBtn(_mapBtn, Global.COLOR_MAP,"地图选择");
			_mapBtn.x = 5;
			_mapBtn.y = _diffBtn.y+_diffBtn.height+15;
			addChild(_mapBtn);
			setChosePanel(_mapPanel, Global.COLOR_MAP, Global.MAP_NUM, _mapButts, _mapTexts);
			_mapPanel.x = _mapBtn.x+_mapBtn.width+5;
			_mapPanel.y = _mapBtn.y;
			addChild(_mapPanel);
			_mapPanel.visible = false;
			
			setBtn(_scoreBtn, Global.COLOR_SCORE,"查看排名");
			_scoreBtn.x = 5;
			_scoreBtn.y = _mapBtn.y+_mapBtn.height+15;
			addChild(_scoreBtn);
			addEvtListeners();
		}
		
		private function addEvtListeners():void
		{
			_diffBtn.addEventListener(MouseEvent.CLICK, switchDiffPanel);
			_mapBtn.addEventListener(MouseEvent.CLICK, switchMapPanel);
			_scoreBtn.addEventListener(MouseEvent.CLICK, switchScorePanel);
			var i:int;
			for(i = 0;i<_diffButts.length;i++)
			{
				if(_diffButts[i])
				{
					_diffButts[i].addEventListener(MouseEvent.CLICK, changeDiff);					
				}
			}
			for(i = 0;i<_mapButts.length &&  _mapButts[i];i++)
			{
				if(_mapButts[i])
				{
					_mapButts[i].addEventListener(MouseEvent.CLICK,changeMap);					
				}
			}
		}
		
		private function switchDiffPanel(evt:MouseEvent):void
		{
			_diffPanel.visible == true ? _diffPanel.visible = false : _diffPanel.visible = true;
			_mapPanel.visible = false;
		}
		
		private function switchMapPanel(evt:MouseEvent):void
		{
			_diffPanel.visible = false;
			_mapPanel.visible == true ? _mapPanel.visible = false : _mapPanel.visible = true;
		}
		
		private function switchScorePanel(evt:MouseEvent):void
		{
			_diffPanel.visible = false;
			_mapPanel.visible = false;
		}
		
		private function changeDiff(evt:MouseEvent):void
		{
			GameControler.instance.pauseGame();
			//pauseGame
			for(var i:int = 1;i<_diffButts.length;i++)
			{
				if(_diffButts[i] && _diffButts[i] == evt.target)
				{
					break;
				}
			}
			Global.speed = i;
			//setNewDIff
		}
		
		private function showTops(evt:MouseEvent):void
		{
			HttpRequest.instance.call('getTops',{'num':3},showTopScores);
		}
		
		private function showTopScores(data:Object):void
		{
			
		}
		
		private function changeMap(evt:MouseEvent):void
		{
			//endGame
			//setName
		}
		
		private function setBg():void
		{
		}
		
		private function setIntroPanel():void
		{
			var declare:TextField = new TextField();
			declare.mouseEnabled = false;
			declare.width = 120;
			declare.height = 90;
			declare.text = ("游戏说明\n");
			declare.appendText("Enter键:\t开始游戏\n");
			declare.appendText("方向键:\t控制方向\n");
			declare.appendText("Esc键:\t\t暂停游戏\n");
			declare.appendText("空格键:\t恢复游戏\n");
			_introPanel.addChild(declare);
		}
		
		private function setBtn(btn:Sprite, color:uint, text:String):void
		{
			btn.graphics.beginFill(color);
			btn.graphics.drawRoundRect(0,0,100,20,10);
			btn.graphics.endFill();
			btn.buttonMode = true;
			
			var tf:TextField = new TextField();
			tf.mouseEnabled = false;
			tf.text = text;
			tf.x = 23;
			tf.y = 3;
			tf.width = btn.width - tf.x;
			tf.height = btn.height;
			btn.addChild(tf);
		}
		
		private function setChosePanel(bg:Sprite, color:uint, num:uint, btnArray:Array, btnTextArray:Array):void
		{
			if(num<1)
			{
				return ;
			}
			var i:int;
			bg.graphics.beginFill(color);
			bg.graphics.drawRoundRect(0,0,30,num*125/7,10,10);
			bg.graphics.endFill();
			for(i=1;i<=num;i++)
			{
				btnArray[i] = new Sprite();
				btnArray[i].buttonMode = true;
				btnTextArray[i] = new TextField();
				(btnTextArray[i] as TextField).mouseEnabled = false;
				btnArray[i].x = 10;
				btnArray[i].y = -10+i*5;
				btnArray[i].graphics.beginFill(0xE0FFFF);
				btnArray[i].graphics.drawRect(0,i*12,12,12);
				btnArray[i].graphics.endFill();
				btnTextArray[i].x = -2;
				btnTextArray[i].y = -2+12*i;
				btnTextArray[i].width = 20;
				btnTextArray[i].text = " "+i+" ";
				btnArray[i].addChild(btnTextArray[i]);
				bg.addChild(btnArray[i]);
			}
				
		}
		
	}
}