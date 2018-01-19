package coco.util
{
	import coco.core.Application;
	import coco.core.coco;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[ExcludeClass]
	public class LinceseUtil
	{
		public function LinceseUtil()
		{
		}
		
		private static var instance:LinceseUtil;
		
		public static function getInstance():LinceseUtil
		{
			if (!instance)
			{
				instance = new LinceseUtil();
			}
			
			return instance;
		}
		
		private var linceseLoader:URLLoader;
		
		public function checkLincese():void
		{
			linceseLoader = new URLLoader();
			linceseLoader.addEventListener(Event.COMPLETE, linceseLoader_completeHandler);
			linceseLoader.addEventListener(IOErrorEvent.IO_ERROR, linceseLoader_errorHandler);
			linceseLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, linceseLoader_securityErrorHandler);
			linceseLoader.load(new URLRequest("http://www.hefeixiaomu.com/cocoui/lincese.json"));
		}
		
		private function linceseLoader_errorHandler(event:IOErrorEvent):void
		{
			core("获取COCOUI授权信息失败");
		}
		
		private function linceseLoader_completeHandler(event:Event):void
		{
			core("获取COCOUI授权信息成功");
			
			try
			{
				var linceseString:String = linceseLoader.data as String;
				var lincese:Object = JSON.parse(linceseString);
				Application.topApplication.coco::hasLincese = lincese.lincese;
			}
			catch (e:Error)
			{
				core("解析COCOUI授权信息失败");
			}
		}
		
		private function linceseLoader_securityErrorHandler(e:SecurityErrorEvent):void
		{
			core("获取COCOUI授权信息失败-沙箱问题");
		}
		
		
	}
}
