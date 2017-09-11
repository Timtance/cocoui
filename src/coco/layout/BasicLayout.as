package coco.layout
{
	
	/**
	 * 基本布局  对元素不进行任何布局操作
	 * 
	 * @author Coco
	 */	
	public class BasicLayout implements ILayout
	{
		public function BasicLayout()
		{
		}
		
		private var _layoutView:ILayoutView;

		public function get layoutView():ILayoutView
		{
			return _layoutView;
		}

		public function set layoutView(value:ILayoutView):void
		{
			_layoutView = value;
		}

		
		/**
		 * 初始化布局
		 */		
		public function initLayout():void
		{
			
		}
		
		/**
		 * 清理布局
		 */		
		public function clearLayout():void
		{
			
		}
		
		/**
		 * 更新布局
		 */		
		public function updateLayout():void
		{
			
		}
		
	}
}