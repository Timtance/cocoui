package coco.helper
{
	import coco.component.IScrollView;
	

	/**
	 * 滚动辅助接口
	 */	
	public interface IScrollHelper
	{
		
		/**
		 * 开始工作 
		 */		
		function startWork():void;
		
		/**
		 * 停止工作
		 */		
		function stopWork():void;
		
		/**
		 * 滚动视图
		 */		
		function get scrollView():IScrollView;
		function set scrollView(value:IScrollView):void;
		
	}
}