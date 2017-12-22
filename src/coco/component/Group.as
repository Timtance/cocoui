package coco.component
{
	import flash.display.DisplayObject;
	
	import coco.core.IUIComponent;
	import coco.event.UIEvent;
	import coco.layout.BasicLayout;
	import coco.layout.ILayout;
	import coco.layout.ILayoutView;
	
	
	/**
	 * 
	 * 布局视图
	 * 
	 * @author coco
	 * 
	 */	
	public class Group extends ScrollView implements ILayoutView
	{
		public function Group()
		{
			super();
			
			mouseScrollEnabled = false // Group默认不支持鼠标
			touchScrollEnabled = false // Group默认不支持触摸滚动
			verticalScrollEnabled = false // Group默认不支持垂直滚动
			horizontalScrollEnabled = false // Group默认不支持水平滚动
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 		//---------------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		
		//------------------------------------------
		// layout
		//------------------------------------------
		
		private var _layout:ILayout = new BasicLayout();
		
		public function get layout():ILayout
		{
			return _layout;
		}
		
		public function set layout(value:ILayout):void
		{
			if (_layout == value) return;
			
			// clear old Layout
			if (_layout)
			{
				_layout.layoutView = null;
				_layout = null;
			}
			_layout = value;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		
		//------------------------------------------
		// horizontalScrollPosition
		//------------------------------------------
		
		override public function set horizontalScrollPosition(value:Number):void
		{
			// 如果值的范围无效 将不会更新布局 提高性能
			if (super.horizontalScrollPosition == value) return;
			super.horizontalScrollPosition = value;
			invalidateLayout();
		}
		
		
		//------------------------------------------
		// verticalScrollPosition
		//------------------------------------------
		
		override public function set verticalScrollPosition(value:Number):void
		{
			// 如果值的范围无效 将不会更新布局 提高性能
			if (super.verticalScrollPosition == value) return;
			super.verticalScrollPosition = value;
			invalidateLayout();
		}	
		
		
		//---------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 		//---------------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (layout)
				layout.layoutView = this;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			scrollRect = null;
			
			// 设置滚动视图属性
			_horizontalScrollPosition = minHorizontalScrollPosition = width;
			_verticalScrollPosition = minVerticalScrollPosition = height;
			
			if (layout)
			{
				layout.initLayout();
				layout.updateLayout();
			}
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		//  失效方法用于单独刷新布局  单独调用布局的updateDisplayList方法，  而省去initLayout过去， 提高性能
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		private var invalidateLayoutFlag:Boolean = false;
		
		/**
		 * 布局的布局失效
		 */		
		private function invalidateLayout():void
		{
			// 如果布局为null  失效也没用 直接返回
			if (!layout) return;
			
			if (!invalidateLayoutFlag)
			{
				invalidateLayoutFlag = true;
				callLater(validateLayout).descript = "validateLayout()";
			}
		}
		
		private function validateLayout():void
		{
			if (invalidateLayoutFlag)
			{
				invalidateLayoutFlag = false;
				updateLayout();
			}
		}
		
		protected function updateLayout():void
		{
			layout.updateLayout();
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 		//---------------------------------------------------------------------------------------------------------------------
		//
		// Add Remove Child Method
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			// listen resize event
			var uicomponent:IUIComponent = child as IUIComponent;
			if (uicomponent && uicomponent.includeInLayout)
				uicomponent.addEventListener(UIEvent.RESIZE, uicomponent_resizeHandler);
			
			// add
			super.addChild(child);
			
			// will invalidate layout
			invalidateDisplayList();
			
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			// listen resize event
			var uicomponent:IUIComponent = child as IUIComponent;
			if (uicomponent && uicomponent.includeInLayout)
				uicomponent.addEventListener(UIEvent.RESIZE, uicomponent_resizeHandler);
			
			// add
			super.addChildAt(child, index);
			
			// will invalidate layout
			invalidateDisplayList();
			
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var uicomponent:IUIComponent = child as IUIComponent;
			if (uicomponent && uicomponent.includeInLayout)
				uicomponent.removeEventListener(UIEvent.RESIZE, uicomponent_resizeHandler);
			
			super.removeChild(child);
			
			// will invalidate layout
			invalidateDisplayList();
			
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			var removedChild:DisplayObject = super.removeChildAt(index);
			var uicomponent:IUIComponent = removedChild as IUIComponent;
			if (uicomponent && uicomponent.includeInLayout)
				uicomponent.removeEventListener(UIEvent.RESIZE, uicomponent_resizeHandler);
			
			// will invalidate layout
			invalidateDisplayList();
			
			return removedChild;
		}
		
		protected function uicomponent_resizeHandler(event:UIEvent):void
		{
			invalidateDisplayList();
		}
		
		
	}
}