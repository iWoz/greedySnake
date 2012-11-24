package util
{
	import com.adobe.serialization.json.*;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.*;
	
	import model.Global;

	public class HttpRequest
	{
		private static var _instance:HttpRequest;
		
		private var m_callback:Function;
		
		public function HttpRequest()
		{
		}
		
		public static function get instance():HttpRequest
		{
			if(!_instance)
			{
				_instance = new HttpRequest();
			}
			return _instance;
		}
		
		public function call(act:String, params:Object, callBackFunc:Function = null):void
		{
			m_callback = callBackFunc;
			
			var reqdata:URLVariables = new URLVariables();
			reqdata['act'] = act;
			for(var key:String in params)
			{
				reqdata[key] = params[key];
			}
			
			var req:URLRequest = new URLRequest(Global.gateway_url);
			req.method = URLRequestMethod.POST;
			req.data = reqdata;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = "text";
			
			loader.addEventListener(Event.COMPLETE, onPushComp);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOErr);
			
			loader.load(req);
		}
		
		private function onPushComp(evt:Event):void
		{
			var resp:Object = new JSONDecoder(evt.currentTarget.data, true).getValue();
			trace(resp);
			if(m_callback != null)
			{
				m_callback(resp);
			}
		}
		
		private function onIOErr(evt:IOErrorEvent):void
		{
			trace(evt.text);
		}
	}
}