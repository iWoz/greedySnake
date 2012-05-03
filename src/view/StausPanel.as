package view
{
	import flash.display.Sprite;
	import flash.text.TextField;

	public class StausPanel extends Sprite
	{
		private static var _instance:StausPanel;
		
		private static var _scoreBar:TextField = new TextField();
		private static var _timeBar:TextField = new TextField();
		private static var _diffBar:TextField = new TextField();
		
		public function StausPanel()
		{
		}
		
		private static function init():void
		{
			_instance = new StausPanel();
			_instance.mouseChildren = false;
			_instance.mouseEnabled = false;
			
			_instance.addChild(_scoreBar);
			_instance.addChild(_timeBar);
			_instance.addChild(_diffBar);
			
			_scoreBar.text = "分数:0";
			_scoreBar.x = 0;
			_scoreBar.y = 0;
			
			_diffBar.text = "难度:0";
			_diffBar.x = 60;
			_diffBar.y = 0;
			
			_timeBar.text = "用时:00:00";
			_timeBar.x = 120;
			_timeBar.y = 0;
			
		}
		
		public static function get instance():StausPanel
		{
			if(!_instance)
			{
				init();
			}
			return _instance;
		}
		
		public function updateScore(score:uint):void
		{
			_scoreBar.text = "分数:"+score;
		}
		
		public function updateDiffculty(diff:uint):void
		{
			_diffBar.text = "难度:"+diff;
		}
		
		public function updateTime(time:String):void
		{
			_timeBar.text = "用时"+time;
		}
	}
}