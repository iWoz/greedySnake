package model
{
	public class Direct
	{
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		
		public function Direct()
		{
		}
		
		public static function isDirection(direction:String):Boolean
		{
			if(direction == Direct.LEFT || direction == Direct.RIGHT ||
				direction == Direct.UP || direction == Direct.DOWN)
			{
				return true;
			}
			return false;
		}
		
	}
}