package coco.event
{
	import flash.events.Event;
	
	public class UIEvent extends Event
	{
		
		/**
		 * 组件预初始化的时候派发 在调用createChildren调用之前派发
		 */		
		public static const PREINITIALIZE:String = "ui_preinitialize";
		
		/**
		 * 组件创建完成的时候派发 在调用createChildren调用之后派发
		 */		
		public static const CREATION_COMPLETE:String = "ui_creationComplete";
		
		/**
		 * 组件大小发生改变的时候派发 
		 */		
		public static const RESIZE:String = "ui_resize";
		
		/**
		 * PopUp组件关闭的时候派发
		 */        
		public static const CLOSE:String = "ui_close";
		
		/**
		 * 界面发生改变的时候派发 包括界面文本  选中的所有等...
		 */
		public static const CHANGE:String = "ui_change";
		
		public function UIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//  Properties
		//
		//----------------------------------------------------------------------------------------------------------------
		
		/**
		 * CLOSE 的时候使用 
		 */        
		public var detail:int;
		
		//----------------------------------
		//  newIndex
		//----------------------------------
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//  Overridden methods: Event
		//
		//----------------------------------------------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function clone():Event
		{
			return new UIEvent(type, bubbles, cancelable);
		}
		
	}
}