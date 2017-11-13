package coco.event
{
	import flash.events.Event;
	
	public class DragEvent extends Event
	{
		
		/**
		 * 拖拽开始 
		 */		
		public static const DRAG_BEGIN:String = "dragBegin";
		
		/**
		 * 拖拽结束
		 */		
		public static const DRAG_END:String = "dragEnd";
		
		/**
		 * 拖拽更新事件 
		 */		
		public static const DRAG_REFRESH:String = "dragRefresh";
		
		/**
		 * 使用翻页布局 翻到尾页结束的时候派发 
		 */		
		public static const PAGE_BEGIN:String = "pageBegin";
		
		/**
		 * 使用翻页布局 翻到首页超出的时候派发 
		 */
		public static const PAGE_END:String = "pageEnd";
		
		
		
		public function DragEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
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
			return new DragEvent(type, bubbles, cancelable);
		}
		
	}
}