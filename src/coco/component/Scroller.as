package coco.component
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import coco.core.coco;
	import coco.event.UIEvent;
	import coco.helper.ScrollHelper;
	
	use namespace coco;
	
	/**
	 * 支持滚动的组件
	 * 
	 * @author Coco
	 */	
	public class Scroller extends ScrollView implements IScrollView
	{
		public function Scroller()
		{
			super();
			
			addEventListener(UIEvent.RESIZE, this_resizeHandler);
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		//  Static const
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		//  Variables
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		private var viewport:DisplayObject;
		
		//------------------------------------------
		//	verticalScrollPosition
		//------------------------------------------
		
		/**
		 * @private
		 */
		override public function set verticalScrollPosition(value:Number):void
		{
			var valueAbs:Number = Math.round(value);
			if (_verticalScrollPosition == valueAbs)
				return;
			
			super.verticalScrollPosition = valueAbs;
			invalidateViewPort();
		}
		
		//------------------------------------------
		//	horizontalScrollPosition
		//------------------------------------------
		
		override public function set horizontalScrollPosition(value:Number):void
		{
			var valueAbs:Number = Math.round(value);
			if (_horizontalScrollPosition == valueAbs)
				return;
			
			super.horizontalScrollPosition = valueAbs;
			invalidateViewPort();
		}
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		//  add remove child
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			installViewPort(child);
			return super.addChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			installViewPort(child);
			return super.addChildAt(child, index);
		}
		
		/**
		 * 安装滚动对象视图
		 * 
		 */		
		private function installViewPort(newViewPort:DisplayObject):void
		{
			// remove old viewport
			if (viewport)
			{
				viewport.removeEventListener(UIEvent.RESIZE, viewport_resizeHandler);
				removeChild(viewport);
			}
			
			// set new viewport
			viewport = newViewPort;
			viewport.addEventListener(UIEvent.RESIZE, viewport_resizeHandler);
			
			invalidateProperties();
		}
		
		private function viewport_resizeHandler(event:UIEvent):void
		{
			invalidateDisplayList();
		}
		
		private function this_resizeHandler(event:UIEvent):void
		{
			invalidateDisplayList();
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		//  override methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		override protected function measure():void
		{
			measuredHeight = measuredWidth = 200;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			// draw background
//			graphics.clear();
//			graphics.beginFill(CocoUI.themeUpFillColor);
//			graphics.drawRect(0, 0, width, height);
//			graphics.endFill();
			
			// scrollRect
			scrollRect = new Rectangle(0, 0, width, height);
			
			var realVerticalScrollEnabled:Boolean = false;
			var realHorizontalScrollEnabled:Boolean = false;
			if (!viewport)
			{
				minHorizontalScrollPosition = maxHorizontalScrollPosition = horizontalScrollPosition = width;
				minVerticalScrollPosition = maxVerticalScrollPosition = verticalScrollPosition = height;
			}
			else
			{
				if (viewport.width > width)
				{
					horizontalScrollPosition = minHorizontalScrollPosition = width;
					maxHorizontalScrollPosition = viewport.width;
					realHorizontalScrollEnabled = true;
				}
				else
					minHorizontalScrollPosition = maxHorizontalScrollPosition = horizontalScrollPosition = width;
				
				if (viewport.height > height)
				{
					verticalScrollPosition = minVerticalScrollPosition = height;
					maxVerticalScrollPosition = viewport.height;
					realVerticalScrollEnabled = true;
				}
				else
					minVerticalScrollPosition = maxVerticalScrollPosition = verticalScrollPosition = height;
			}
			
			realVerticalScrollEnabled = realVerticalScrollEnabled && verticalScrollEnabled;
			realHorizontalScrollEnabled = realHorizontalScrollEnabled && horizontalScrollEnabled;
			
			if (realHorizontalScrollEnabled || realVerticalScrollEnabled)
			{
				if (!scrollHelper)
					scrollHelper = new ScrollHelper();
				
				scrollHelper.startWork();
			}
			else
			{
				if (scrollHelper)
					scrollHelper.stopWork();
			}
			
			invalidateViewPort();
		}
		
		private var invalidateViewPortFlag:Boolean = false;
		
		private function invalidateViewPort():void
		{
			if (!invalidateViewPortFlag)
			{
				invalidateViewPortFlag = true;
				callLater(validateViewPort).descript = "validateViewPort()";
			}
		}
		
		private function validateViewPort():void
		{
			if (invalidateViewPortFlag)
			{
				invalidateViewPortFlag = false;
				updateViewPort();
			}
		}
		
		private function updateViewPort():void
		{
			if (viewport)
			{
				viewport.x = minHorizontalScrollPosition - horizontalScrollPosition;
				viewport.y = minVerticalScrollPosition - verticalScrollPosition;
			}
		}
		
	}
}