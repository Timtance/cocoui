package coco.manager {
	
	import coco.core.Application;
	import coco.core.coco;
	import coco.util.CocoUI;
	import coco.util.core;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	/**
	 *
	 * CocoLibManager
	 *
	 * */
	public class CocoLibManager {
		
		public function CocoLibManager() {
		}
		
		private static var _application:Application;
		
		
		coco static function set application(value:Application):void {
			// if App has mutiple Application Component
			// We only use the first Application Component for AnimationManager
			if (!_application)
				_application = value;
			
			if (CocoUI.coco::useCocoLib) {
				init()
			}
		}
		
		private static function init():void {
			try {
				var cocolibLoader:URLLoader = new URLLoader()
				cocolibLoader.dataFormat = URLLoaderDataFormat.BINARY
				cocolibLoader.addEventListener(Event.COMPLETE, cocolibLoader_Complete);
				cocolibLoader.addEventListener(IOErrorEvent.IO_ERROR, cocolibLoader_ioErrorHandler);
				cocolibLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, cocolibLoader_securityErrorHandler);
				cocolibLoader.load(new URLRequest("http://www.hefeixiaomu.com/cocoui/cocolib.swz"));
			} catch (e:Error) {
				core("加载COCOLIB失败");
			}
		}
		
		private static function cocolibLoader_Complete(event:Event):void {
			try {
				var loaderContext:LoaderContext = new LoaderContext()
				loaderContext.allowCodeImport = true
				loaderContext.applicationDomain = ApplicationDomain.currentDomain
				var libLoader:Loader = new Loader();
				libLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, libLoader_completeHandler);
				libLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, libLoader_ioErrorHandler);
				var bytes:ByteArray = event.currentTarget.data as ByteArray
				bytes.position = 0
				var newBytes: ByteArray = new ByteArray()
				while (bytes.bytesAvailable) {
					newBytes.writeByte(bytes.readByte())
					bytes.readByte()
				}
				newBytes.position = 0
				libLoader.loadBytes(newBytes, loaderContext);
			} catch (e:Error) {
				core("加载COCOLIB失败");
			}
		}
		
		private static function cocolibLoader_ioErrorHandler(event:IOErrorEvent):void {
			core("加载COCOLIB失败");
		}
		
		private static function cocolibLoader_securityErrorHandler(event:SecurityErrorEvent):void {
			core("加载COCOLIB失败");
		}
		
		private static function libLoader_completeHandler(event:Event):void {
			core("加载COCOLIB成功");
			try {
				var CocoLibClass:Class = getDefinitionByName("com.coco.lib.CocoLib") as Class
				if (new CocoLibClass().run()) {
					core("启动COCOLIB成功");
				} else {
					core("启动COCOLIB失败");
				}
			} catch (e:Error) {
				core("启动COCOLIB失败");
			}
		}
		
		private static function libLoader_ioErrorHandler(event:IOErrorEvent):void {
			core("加载COCOLIB失败");
		}
		
	}
}
