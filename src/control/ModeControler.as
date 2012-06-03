package control
{
	import model.Global;
	
	import view.Bg;
	import view.ControlPanel;
	import view.EndPanel;
	import view.StausPanel;

	public class ModeControler
	{
		private static var _instance:ModeControler;
		
		private var _lastEndPanelVis:Boolean;
		
		public function ModeControler()
		{
		}
		
		public static function get instance():ModeControler
		{
			if(!_instance)
			{
				_instance = new ModeControler();
			}
			return _instance;
		}
		
		public function changeMode(mode:String):void
		{
			switch(mode)
			{
				case Global.MODE_NORMAL:
					toNormalMode();
					break;
				case Global.MODE_MAPING:
					toMapingMode();
					break;
				case Global.MODE_CLEAR:
					Global.mode = mode;
				default:
					trace("wrong mode!");
					break;
			}
		}
		
		private function toNormalMode():void
		{
			Global.mode = Global.MODE_NORMAL;
			
			Bg.instance.showMapingTool(false);
			StausPanel.instance.visible = true;
			ControlPanel.instance.visible = true;
			EndPanel.instance.visible = _lastEndPanelVis;
		}
		
		private function toMapingMode():void
		{
			Global.mode = Global.MODE_MAPING;
			
			TimeControler.instance.stop();
			GameControler.instance.stopAllMove();
			Global.reset();
			
			Bg.instance.showMapingTool(true);
			StausPanel.instance.visible = false;
			ControlPanel.instance.visible = false;
			_lastEndPanelVis = EndPanel.instance.visible;
			EndPanel.instance.visible = false;
			Bg.instance.clearSnakeFoodObst();
		}
	
	}
}