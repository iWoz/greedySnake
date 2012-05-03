package control
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import model.Global;
	
	import util.Utils;
	
	import view.StausPanel;

	public class TimeControler extends EventDispatcher 
	{
		
		public static var TICK:String = "tick";
		public static var MOVE:String = "move";
		
		private static var _instance:TimeControler;
		
		private var tickTimer:Timer = new Timer(1000);
		private var moveTimer:Timer = new Timer(200);
		
		public function TimeControler()
		{
		}
		
		public static function get instance():TimeControler
		{
			if(!_instance)
			{
				_instance = new TimeControler();
			}
			return _instance;
		}
		
		public function start():void
		{
			tickTimer.start();
			tickTimer.addEventListener(TimerEvent.TIMER, onTick);
			moveTimer.start();
			moveTimer.addEventListener(TimerEvent.TIMER, onMove);
		}
		
		public function stop():void
		{
			tickTimer.stop();
			tickTimer.removeEventListener(TimerEvent.TIMER, onTick);
			moveTimer.stop();
			moveTimer.removeEventListener(TimerEvent.TIMER, onMove);
		}
		
		public function changeSpeed(speed:uint):void
		{
			Global.speed = speed;
			moveTimer.delay = 400/speed;
		}
		
		private function onTick(evt:TimerEvent):void
		{
			dispatchEvent(new Event(TimeControler.TICK));
		}
		
		private function onMove(evt:TimerEvent):void
		{
//			StausPanel.instance.updateScore(Global.score);
			dispatchEvent(new Event(TimeControler.MOVE));
		}
	}
}