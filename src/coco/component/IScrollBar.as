package coco.component
{
	import coco.core.IUIComponent;
	
	/**
	 *
	 * 滚动容器的滚动条接口
	 *  
	 * @author coco
	 * 
	 */	
	public interface IScrollBar extends IUIComponent
	{
		function get scrollView():IScrollView;
		function set scrollView(value:IScrollView):void;
		
		/**
		 * 更新滚动条
		 */		
		function updateScrollBar():void;
	}
}