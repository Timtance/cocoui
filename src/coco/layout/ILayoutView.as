package coco.layout
{
	import coco.component.IScrollView;
	
	
	/**
	 *
	 * 布局视图接口
	 *  
	 * @author coco
	 * 
	 */	
	public interface ILayoutView extends IScrollView
	{
		
		/**
		 * 布局
		 */		
		function get layout():ILayout;
		function set layout(value:ILayout):void;
		
	}
}