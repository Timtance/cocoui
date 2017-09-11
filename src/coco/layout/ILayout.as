package coco.layout
{
	
	/**
	 * 布局接口
	 */	
	public interface ILayout
	{
		
		/**
		 * 布局视图
		 */		
		function get layoutView():ILayoutView;
		function set layoutView(value:ILayoutView):void;
		
		/**
		 * 初始化布局
		 */		
		function initLayout():void;
		
		/**
		 * 清理布局
		 */		
		function clearLayout():void;
		
		/**
		 * 更新布局
		 */		
		function updateLayout():void;
	}
}