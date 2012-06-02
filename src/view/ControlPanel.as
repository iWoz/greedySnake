package view
{
	import control.GameControler;
	import control.TimeControler;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
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
		private var _topsText:TextField = new TextField();
		
		private var _diffButts:Array = [];
		private var _diffTexts:Array = [];
		
		private var _mapButts:Array = [];
		private var _mapTexts:Array = [];
		
		private var _panels:Object = {"diff":_diffPanel, "map":_mapPanel, "score":_scorePanel};
		
		public function ControlPanel()
		{
			setIntroPanel();
			addChild(_introPanel);
			
			setBtn(_diffBtn,Global.COLOR_DIFF,"难度选择");
			_diffBtn.x = 5;
			_diffBtn.y = _introPanel.y + _introPanel.height;
			addChild(_diffBtn);
			_diffBtn.name = "diff";
			
			setChosePanel(_diffPanel, Global.COLOR_DIFF, Global.DIFF_NUM, _diffButts, _diffTexts);
			_diffPanel.x = _diffBtn.x+_diffBtn.width+5;
			_diffPanel.y = _diffBtn.y;
			addChild(_diffPanel);
			_diffPanel.visible = false;
			
			setBtn(_mapBtn, Global.COLOR_MAP,"地图选择");
			_mapBtn.x = 5;
			_mapBtn.y = _diffBtn.y+_diffBtn.height+15;
			addChild(_mapBtn);
			_mapBtn.name = "map";
			
			setChosePanel(_mapPanel, Global.COLOR_MAP, Global.MAP_NUM, _mapButts, _mapTexts);
			_mapPanel.x = _mapBtn.x+_mapBtn.width+5;
			_mapPanel.y = _mapBtn.y;
			addChild(_mapPanel);
			_mapPanel.visible = false;
			
			setBtn(_scoreBtn, Global.COLOR_SCORE,"查看排名");
			_scoreBtn.x = 5;
			_scoreBtn.y = _mapBtn.y+_mapBtn.height+15;
			addChild(_scoreBtn);
			_scoreBtn.name = "score";
			
			_scorePanel.graphics.beginFill(Global.COLOR_SCORE);
			_scorePanel.graphics.drawRoundRect(0,0,150,100,10,10);
			_scorePanel.graphics.endFill();
			_scorePanel.x = _scoreBtn.x+_scoreBtn.width+5;
			_scorePanel.y = _scoreBtn.y - 50;
			addChild(_scorePanel);
			_scorePanel.visible = false;
			
			_topsText.width = _scorePanel.width;
			_topsText.x = 6;
			_scorePanel.addChild(_topsText);
			
			addEvtListeners();
		}
		
		private function addEvtListeners():void
		{
			_diffBtn.addEventListener(MouseEvent.CLICK, switchVisible);
			_mapBtn.addEventListener(MouseEvent.CLICK, switchVisible);
			_scoreBtn.addEventListener(MouseEvent.CLICK, switchVisible);
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
		
		private function switchVisible(evt:MouseEvent):void
		{
			for(var panelname:String in _panels)
			{
				if(panelname == evt.currentTarget.name)
				{
					_panels[panelname].visible = !(_panels[panelname].visible);
				}
				else
				{
					_panels[panelname].visible = false;
				}
				if(panelname == "score")
				{
					showTops();
				}
			}
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
		
		private function changeMap(evt:MouseEvent):void
		{
			//endGame
			//setName
		}
		
		private function showTops():void
		{
			HttpRequest.instance.call('getTops',{'num':3},showTopScores);
		}
		
		private function showTopScores(data:Object):void
		{
			_topsText.text = "排名\t\t玩家\t\t分数\r\n";
			var topnames:Array = ["神马","神马","神马"];
			var topscores:Array = [0,0,0];
			if( data && data.hasOwnProperty("code") && data["code"] == 0 )
			{
				var i:int = 0;
				for each(var player:Object in data["data"])
				{
					if(i<topnames.length)
					{
						topnames[i] = player["name"];
						topscores[i] = player["score"];
					}
					i++;
				}
			}
			_topsText.appendText("1st\t\t"+topnames[0]+"\t\t"+topscores[0]+"\r\n");
			_topsText.appendText("2nd\t\t"+topnames[1]+"\t\t"+topscores[1]+"\r\n");
			_topsText.appendText("3rd\t\t"+topnames[2]+"\t\t"+topscores[2]+"\r\n");
		}
		
		private function fillTops(data:Object):void
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