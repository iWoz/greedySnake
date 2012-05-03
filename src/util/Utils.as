package util
{
	public class Utils
	{
		public function Utils()
		{
		}
		
		public static function getFixTime(seconds:int):String
		{
			if(seconds < 0 || seconds > 3600)
			{
				return "00:00";
			}
			return (int(seconds/60) < 10 ? "0"+int(seconds/60):int(seconds/60))+
				":"+(int(seconds%60) < 10 ? "0"+int(seconds%60):int(seconds%60));
		}
		
	}
}