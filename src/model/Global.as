package model
{
	import util.Utils;
	
	import view.StausPanel;

	public class Global
	{
		public static var started:Boolean = false;
		public static var lived:Boolean = false; 
		public static var paused:Boolean = false;
		public static var direction:String = Direct.LEFT;
		public static var score:int = 0;
		public static var speed:int = 2;
		private static var timer_s:int = 0;
		
		public static var moveLock:Boolean = false;
		
		public static const DIFF_NUM:int = 7;
		public static const MAP_NUM:int = 5;
		public static const TOP_NUM:int = 3;
		public static const COLOR_DIFF:uint = 0xFF2400;
		public static const COLOR_MAP:uint = 0x66FF00;
		public static const COLOR_SCORE:uint = 0x007FFF;
		public static const COLOR_FOOD:uint = 0x66FF00;
		public static const COLOR_SNAKE:uint = 0xfff000;
		public static const POOL_WIDTH:uint = 200;
		public static const POOL_HEIGHT:uint = 200;
		public static const SNAKE_KNOT_LENGTH:uint = 10;
		public static const FOOD_LENGTH:uint = 10;
		public static const OBSTACLE_LENGTH:uint = 10;
		
	
		public static function set timer(t:int):void
		{
			Global.timer_s = t;
			StausPanel.instance.updateTime(Utils.getFixTime(t));
		}
		
		public static function get timer():int
		{
			return Global.timer_s;
		}
		
		public function Global()
		{
		}
	}
}