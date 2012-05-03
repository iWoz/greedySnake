package util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import flashx.undo.IOperation;

	public class XMLReader
	{
		private const ERR_FLAG:XML = new XML("__ERR!__");
		
		private var _pool:Dictionary;
		
		
		private static var _instance:XMLReader;
		
		public function XMLReader()
		{
			_pool = new Dictionary();
		}
		
		public static function get instance():XMLReader
		{
			if(!_instance)
			{
				_instance = new XMLReader();
			}
			return _instance;
		}
		
		public function addXMLByName(name:String,xml:XML):void
		{
			_pool[name] = xml;
		}
		
		
		public function getXMLByName(name:String):XML
		{
			if(_pool.hasOwnProperty(name) && _pool[name])
			{
				return _pool[name] as XML;
			}
			return null;
		}
	}
}