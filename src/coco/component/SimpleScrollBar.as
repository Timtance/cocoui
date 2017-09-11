package coco.component
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import coco.core.UIComponent;
	
	[ExcludeClass]
	/**
	 * 
	 * 简易滚动条
	 * 
	 * @author coco
	 * 
	 */	
	public class SimpleScrollBar extends UIComponent implements IScrollBar
	{
		public function SimpleScrollBar()
		{
			super();
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		//---------------------
		//	scrollView
		//---------------------
		
		private var _scrollView:IScrollView;
		
		public function get scrollView():IScrollView
		{
			return _scrollView;
		}
		
		public function set scrollView(value:IScrollView):void
		{
			_scrollView = value;
		}
		
		/**
		 * 滚动条消失延时计时器id 
		 */		
		private var delayHideTime:int;
		
		private var horizontalScrollBarWasDrawed:Boolean = false;
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 更新滚动条显示
		 */		
		public function updateScrollBar():void
		{
			if (!scrollView) return;
			
			clearTimeout(delayHideTime);
			width = parent.width;
			height = parent.height;
			
			// draw verticalScroll Simple Bar
			graphics.clear();
			graphics.beginFill(0x000000, .5);
			if (scrollView.horizontalScrollEnabled)
			{
				var barWidthScale:Number = scrollView.minHorizontalScrollPosition / scrollView.maxHorizontalScrollPosition
				var barXScale:Number = (scrollView.horizontalScrollPosition - scrollView.minHorizontalScrollPosition) / scrollView.maxHorizontalScrollPosition;
				var barX:Number = barXScale * width;
				var barWidth:Number = Math.max(barWidthScale * width, 10);
				
				if (barX < 0)
				{
					barWidth = barWidth + barX;
					barX = 0;
				}
				if ((barX + barWidth) > width)
					barWidth = width - barX;
				
				if (barWidthScale != 1)
				{
					graphics.drawRoundRect(barX + 2, height - 6, barWidth - 4, 4, 6);
					horizontalScrollBarWasDrawed = true;
				}
			}
			if (scrollView.verticalScrollEnabled)
			{
				var barHeightScale:Number = scrollView.minVerticalScrollPosition / scrollView.maxVerticalScrollPosition;
				var barYScale:Number = (scrollView.verticalScrollPosition - scrollView.minVerticalScrollPosition) / scrollView.maxVerticalScrollPosition;
				var barY:Number = barYScale * height;
				var barHeight:Number = Math.max(barHeightScale * height, 10);
				
				if (barY < 0)
				{
					barHeight = barHeight + barY;
					barY = 0;
				}
				if ((barY + barHeight) > height)
					barHeight = height - barY;
				
				if (barHeightScale != 1)
					graphics.drawRoundRect(width - 6, barY + 2, 4, barHeight - (horizontalScrollBarWasDrawed ? 10 : 4), 6);
			}
			graphics.endFill();
			
			delayHideTime = setTimeout(hideScrollBar, 1500);
		}
		
		private function hideScrollBar():void
		{
			// clear 
			graphics.clear();
		}
		
	}
}