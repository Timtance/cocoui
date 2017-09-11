package coco.component
{
	import flash.text.TextFormatAlign;
	
	import coco.core.coco;
	import coco.layout.BasicLayout;
	import coco.layout.ILayout;
	
	use namespace coco;
	
	/**
	 * 
	 * Panel
	 * 
	 * ------------------
	 * |      title     |
	 * ------------------
	 * |                |
	 * |     content    |
	 * |                |
	 * |                |
	 * ------------------
	 * 
	 * @author Coco
	 * 
	 */    
	public class Panel extends RawView
	{
		public function Panel()
		{
			super();
			
			autoDrawSkin = true;
			
			// 默认添加实际视图
			realView = new Group();
			addRawChild(realView);
		}
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		protected var titleDisplay:Label;
		
		//------------------------------------------
		// headerHeight
		//------------------------------------------
		
		private var _titleHeight:Number = 30;
		
		/**
		 * 头部高度 如果为0  将不显示头部
		 */
		public function get titleHeight():Number
		{
			return _titleHeight;
		}
		
		public function set titleHeight(value:Number):void
		{
			if (_titleHeight == value)
				return;
			_titleHeight = value;
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		//------------------------------------------
		// title
		//------------------------------------------
		
		private var _title:String;
		
		/**
		 * 标题
		 */        
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			if (_title == value) 
				return;
			_title = value;
			invalidateProperties();
		}
		
		
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
			_layout = value;
			invalidateProperties();
		}
		
		
		//------------------------------------------
		// contentWidth
		//------------------------------------------
		
		/**
		 * 内容宽度
		 */		
		public function get contentWidth():Number
		{
			if (realView)
				return realView.width;
			else
				return NaN;
		}
		
		/**
		 * 内容高度  减去头部高度所得到的高度
		 */		
		public function get contentHeight():Number
		{
			if (realView)
				return realView.height;
			else
				return NaN;
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			// header display
			titleDisplay = new Label();
			titleDisplay.textAlign = TextFormatAlign.CENTER;
			addRawChild(titleDisplay);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			titleDisplay.text = title;
			
			Group(realView).layout = layout;
		}
		
		override protected function measure():void
		{
			measuredWidth = 250;
			measuredHeight = titleHeight + 220; 
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			titleDisplay.width = realView.width = width;
			realView.y = titleDisplay.height = titleHeight;
			realView.height = height - realView.y;
		}
		
		override protected function drawSkin():void
		{
			super.drawSkin();
			
			graphics.beginFill(backgroundColor, backgroundAlpha);
			graphics.drawRoundRectComplex(0, titleHeight, contentWidth, contentHeight, 
				0, 0, bottomLeftRadius, bottomRightRadius);
			graphics.endFill();
		}
		
	}
}