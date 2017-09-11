package coco.component
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import coco.core.UIComponent;
	import coco.helper.IScrollHelper;
	import coco.helper.ScrollHelper;
	
	[Event(name="dragBegin", type="coco.event.DragEvent")]
	
	[Event(name="dragEnd", type="coco.event.DragEvent")]
	
	[Event(name="dragRefresh", type="coco.event.DragEvent")]
	
	/**
	 * 抽象滚动类 不要手动实例此类
	 * 
	 * @author coco
	 * 
	 */	
	public class ScrollView extends RawView implements IScrollView
	{
		public function ScrollView()
		{
			super();
			
			autoDrawSkin = true;
			backgroundAlpha = borderAlpha = 0;
			
			// 默认添加实际视图
			realView = new UIComponent();
			addRawChild(realView);
			
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 		//---------------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		private var overLayer:UIComponent;
		
		/**
		 * 是否支持鼠标滚动 
		 */		
		public var mouseScrollEnabled:Boolean = true;
		
		/**
		 * 是否支持拖拽滚动 
		 */		
		public var touchScrollEnabled:Boolean = true;
		
		//------------------------------------------
		// scrollHelper
		//------------------------------------------
		
		protected var _scrollHelper:IScrollHelper = new ScrollHelper();
		
		public function get scrollHelper():IScrollHelper
		{
			return _scrollHelper;
		}
		
		public function set scrollHelper(value:IScrollHelper):void
		{
			if (_scrollHelper == value) return;
			
			// clear old scrollHelper
			if (_scrollHelper)
			{
				_scrollHelper.stopWork();
				_scrollHelper.scrollView = null;
				_scrollHelper = null;
			}
			
			_scrollHelper = value;
			invalidateProperties();
		}
		
		
		//------------------------------------------
		// scrollBar
		//------------------------------------------
		
		protected var _scrollBar:IScrollBar = new SimpleScrollBar();
		
		public function get scrollBar():IScrollBar
		{
			return _scrollBar;
		}
		
		public function set scrollBar(value:IScrollBar):void
		{
			if (_scrollBar == value) return;
			
			if (_scrollBar)
			{
				_scrollBar.scrollView = null;
				_scrollBar = null;
				overLayer.removeAllChild();
			}
			
			_scrollBar = value;
			invalidateProperties();
		}
		
		
		//------------------------------------------
		// minHorizontalScrollPosition
		//------------------------------------------
		
		private var _minHorizontalScrollPosition:Number = 0;
		
		public function get minHorizontalScrollPosition():Number
		{
			return _minHorizontalScrollPosition;
		}
		
		public function set minHorizontalScrollPosition(value:Number):void
		{
			value = Math.ceil(value);
			_minHorizontalScrollPosition = value;
		}
		
		//------------------------------------------
		// maxHorizontalScrollPosition
		//------------------------------------------
		
		private var _maxHorizontalScrollPosition:Number = 0;
		
		public function get maxHorizontalScrollPosition():Number
		{
			if (_maxHorizontalScrollPosition < minHorizontalScrollPosition) 
				return minHorizontalScrollPosition;
			else
				return _maxHorizontalScrollPosition;
		}
		
		public function set maxHorizontalScrollPosition(value:Number):void
		{
			value = Math.ceil(value);
			_maxHorizontalScrollPosition = value;
		}
		
		
		//------------------------------------------
		// horizontalScrollPosition
		//------------------------------------------
		
		protected var _horizontalScrollPosition:Number = NaN;
		
		public function get horizontalScrollPosition():Number
		{
			return _horizontalScrollPosition;
		}
		
		public function set horizontalScrollPosition(value:Number):void
		{
			value = Math.ceil(value);
			if (_horizontalScrollPosition == value) return;
			_horizontalScrollPosition = value;
			invalidateScrollBar();
		}
		
		//------------------------------------------
		// minVerticalScrollPosition
		//------------------------------------------
		
		private var _minVerticalScrollPosition:Number = 0;
		
		public function get minVerticalScrollPosition():Number
		{
			return _minVerticalScrollPosition;
		}
		
		public function set minVerticalScrollPosition(value:Number):void
		{
			value = Math.ceil(value);
			_minVerticalScrollPosition = value;
		}
		
		//------------------------------------------
		// maxVerticalScrollPosition
		//------------------------------------------
		
		private var _maxVerticalScrollPosition:Number = 0;
		
		public function get maxVerticalScrollPosition():Number
		{
			if (_maxVerticalScrollPosition < minVerticalScrollPosition) 
				return minVerticalScrollPosition;
			else
				return _maxVerticalScrollPosition;
		}
		
		public function set maxVerticalScrollPosition(value:Number):void
		{
			value = Math.ceil(value);
			_maxVerticalScrollPosition = value;
		}
		
		//------------------------------------------
		// verticalScrollPosition
		//------------------------------------------
		
		protected var _verticalScrollPosition:Number = NaN;
		
		public function get verticalScrollPosition():Number
		{
			return _verticalScrollPosition;
		}
		
		public function set verticalScrollPosition(value:Number):void
		{
			value = Math.ceil(value);
			if (_verticalScrollPosition == value) return;
			_verticalScrollPosition = value;
			invalidateScrollBar();
		}
		
		//------------------------------------------
		// pageScrollEnabled
		//------------------------------------------
		
		protected var _pageScrollEnabled:Boolean = false;
		
		public function get pageScrollEnabled():Boolean
		{
			return _pageScrollEnabled;
		}
		
		public function set pageScrollEnabled(value:Boolean):void
		{
			_pageScrollEnabled = value;
		}
		
		//------------------------------------------
		// verticalScrollEnabled
		//------------------------------------------
		
		protected var _verticalScrollEnabled:Boolean = true;
		
		public function get verticalScrollEnabled():Boolean
		{
			return _verticalScrollEnabled;
		}
		
		public function set verticalScrollEnabled(value:Boolean):void
		{
			if (_verticalScrollEnabled == value) return;
			_verticalScrollEnabled = value;
			invalidateProperties();
		}
		
		//------------------------------------------
		// horizontalScrollEnabled
		//------------------------------------------
		
		protected var _horizontalScrollEnabled:Boolean = true;
		
		public function get horizontalScrollEnabled():Boolean
		{
			return _horizontalScrollEnabled;
		}
		
		public function set horizontalScrollEnabled(value:Boolean):void
		{
			if (_horizontalScrollEnabled == value) return;
			_horizontalScrollEnabled = value;
			invalidateProperties();
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 		//---------------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			overLayer = new UIComponent();
			addRawChild(overLayer);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (scrollHelper)
				scrollHelper.scrollView = this;
			
			if (touchScrollEnabled)
			{
				if (scrollHelper)
					scrollHelper.startWork();
			}
			else
			{
				if (scrollHelper)
					scrollHelper.stopWork();
			}
			
			if (scrollBar)
			{
				scrollBar.scrollView = this;
				overLayer.addChild(scrollBar as DisplayObject);
			}
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			// scroll view width default scrollRect
			scrollRect = new Rectangle(0, 0, width + 1, height + 1);
			
			realView.width = overLayer.width = width;
			realView.height = overLayer.height = height;
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		//  失效方法用于刷新滚动条
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		private var invalidateScrollBarFlag:Boolean = false;
		
		/**
		 * 布局失效
		 */		
		protected function invalidateScrollBar():void
		{
			if (!scrollBar) return;
			
			if (!invalidateScrollBarFlag)
			{
				invalidateScrollBarFlag = true;
				callLater(validateScrollBar).descript = "validateScrollBar()";
			}
		}
		
		protected function validateScrollBar():void
		{
			if (invalidateScrollBarFlag)
			{
				invalidateScrollBarFlag = false;
				updateScrollBar();
			}
		}
		
		protected function updateScrollBar():void
		{
			scrollBar.updateScrollBar();
		}
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		//  鼠标滚动实现
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		protected function mouseWheelHandler(event:MouseEvent):void
		{
			if (!mouseScrollEnabled) return;
			
			if (verticalScrollEnabled)
			{
				var newVerticalScrollPosition:Number = verticalScrollPosition - event.delta * 5;
				if (newVerticalScrollPosition > maxVerticalScrollPosition)
					newVerticalScrollPosition = maxVerticalScrollPosition;
				if (newVerticalScrollPosition < minVerticalScrollPosition)
					newVerticalScrollPosition = minVerticalScrollPosition;
				verticalScrollPosition =  newVerticalScrollPosition;
			}
			else if (horizontalScrollEnabled)
			{
				var newHorizontalScrollPosition:Number = horizontalScrollPosition - event.delta * 5;
				if (newHorizontalScrollPosition > maxHorizontalScrollPosition)
					newHorizontalScrollPosition = maxHorizontalScrollPosition;
				if (newHorizontalScrollPosition < minHorizontalScrollPosition)
					newHorizontalScrollPosition = minHorizontalScrollPosition;
				
				horizontalScrollPosition =  newHorizontalScrollPosition;
			}
		}
		
	}
}