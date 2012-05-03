package view.knot
{
	import flash.display.Sprite;
	
	import model.KnotType;
	
	public class Knot extends Sprite
	{
		protected var _knot:Sprite;
		protected var _type:String;
		
		public function Knot(type:String = KnotType.NOTHING, color:uint = 0x000000,alpha:Number = 1.0)
		{
			_type = type;
			_knot =  new Sprite();
			addChild(_knot);
			_knot.mouseChildren = false;
			_knot.mouseEnabled = false;
			_knot.graphics.beginFill(color,alpha);
		}
		
		public function get type():String
		{
			return _type;
		}
	}
}