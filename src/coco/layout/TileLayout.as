package coco.layout
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import coco.core.IUIComponent;
	import coco.component.HorizontalAlign;
	import coco.component.VerticalAlign;
	
	
	/**
	 *
	 * 用于LayoutView的布局
	 *  
	 * @author coco
	 * 
	 */	
	public class TileLayout implements ILayout
	{
		public function TileLayout()
		{
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 		//---------------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		private var _layoutView:ILayoutView;
		
		public function get layoutView():ILayoutView
		{
			return _layoutView;
		}
		
		public function set layoutView(value:ILayoutView):void
		{
			_layoutView = value;
		}
		
		
		//------------------------------------------
		// columnCount
		//------------------------------------------
		
		private var _columnCount:int = 0;
		
		public function get columnCount():int
		{
			return _columnCount;
		}
		
		public function set columnCount(value:int):void
		{
			if (_columnCount == value) return;
			_columnCount = value;
			if (layoutView)
				layoutView.invalidateDisplayList();
		}
		
		
		//------------------------------------------
		// rowCount
		//------------------------------------------
		
		/**
		 * 默认1行显示的方式 
		 */		
		private var _rowCount:int = 1;
		
		public function get rowCount():int
		{
			return _rowCount;
		}
		
		public function set rowCount(value:int):void
		{
			if (rowCount == value) return;
			rowCount = value;
			if (layoutView)
				layoutView.invalidateDisplayList();
		}
		
		
		//------------------------------------------
		// horizontalAlign 
		//------------------------------------------
		
		private var _horizontalAlign:String = HorizontalAlign.CENTER;
		
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			if (_horizontalAlign == value) return;
			_horizontalAlign = value;
			if (layoutView)
				layoutView.invalidateDisplayList();
		}
		
		
		//------------------------------------------
		// verticalAlign 
		//------------------------------------------
		
		private var _verticalAlign:String = VerticalAlign.MIDDLE;
		
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			if (_verticalAlign == value) return;
			_verticalAlign = value;
			if (layoutView)
				layoutView.invalidateDisplayList();
		}
		
		//------------------------------------------
		// padding 
		//------------------------------------------
		
		private var _padding:Number = 0;
		
		public function get padding():Number
		{
			return _padding;
		}
		
		public function set padding(value:Number):void
		{
			if (_padding == value) return;
			_padding = value;
			
			_paddingLeft = _paddingRight = _paddingTop = _paddingBottom = _padding;
			if (layoutView)
				layoutView.invalidateDisplayList();
		}
		
		
		//------------------------------------------
		// paddingLeft 
		//------------------------------------------
		
		private var _paddingLeft:Number = 0;
		
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			if (_paddingLeft == value) return;
			_paddingLeft = value;
			if (layoutView)
				layoutView.invalidateDisplayList();
		}
		
		
		//------------------------------------------
		// paddingTop 
		//------------------------------------------
		
		private var _paddingTop:Number = 0;
		
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			if (_paddingTop == value) return;
			_paddingTop = value;
			if (layoutView)
				layoutView.invalidateDisplayList();
		}
		
		//------------------------------------------
		// paddingRight 
		//------------------------------------------
		
		private var _paddingRight:Number = 0;
		
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			if (_paddingRight == value) return;
			_paddingRight = value;
			if (layoutView)
				layoutView.invalidateDisplayList();
		}
		
		//------------------------------------------
		// paddingBottom 
		//------------------------------------------
		
		private var _paddingBottom:Number =  0;
		
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			if (_paddingBottom == value) return;
			_paddingBottom = value;
			if (layoutView)
				layoutView.invalidateDisplayList();
		}
		
		
		//------------------------------------------
		// gap 
		//------------------------------------------
		
		private var _gap:Number = 0;
		
		public function get gap():Number
		{
			return _gap;
		}
		
		public function set gap(value:Number):void
		{
			if (_gap == value) return;
			_gap = value;
			if (layoutView)
				layoutView.invalidateDisplayList();
		}
		
		//---------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 		//---------------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		protected var realCellCount:int;
		protected var realCellColumns:int;
		protected var realCellRows:int;
		protected var realCellWidth:Number = 0;
		protected var realCellHeight:Number = 0;
		protected var realCellOriginPoint:Point = new Point(); // 细胞原点坐标 用于虚拟布局 细胞布局的起点坐标
		protected var realCellShowPoint:Point = new Point(); // 细胞显示最大点
		
		public function initLayout():void
		{
			// 获取细胞元素的实际数目 实际的细胞列数 实际的细胞行数
			realCellCount = layoutView.numChildren;
			if (realCellCount == 0) return;
			
			if (columnCount > 0) // 如果细胞列数大于0  按列数来排序
			{
				realCellColumns = columnCount;
				realCellRows = Math.ceil(realCellCount / realCellColumns);  // 细胞行数
			}
			else if (rowCount > 0) //  按行数来排序
			{
				realCellRows = rowCount
				realCellColumns = Math.ceil(realCellCount / realCellRows);  // 细胞行数
			}
			else
			{
				realCellColumns = 1;
				realCellRows = realCellCount;
			}
			
			// 获取细胞的最大高度 宽度
			var cell:DisplayObject;
			for (var i:int = 0; i < realCellCount; i++)
			{
				cell = layoutView.getChildAt(i);
				realCellWidth = Math.max(realCellWidth, cell.width);
				realCellHeight = Math.max(realCellHeight, cell.height);
			}
			
			if (horizontalAlign == HorizontalAlign.JUSTIFY)
				realCellWidth =  (layoutView.minHorizontalScrollPosition - paddingLeft - paddingRight - (realCellColumns - 1) * gap) / realCellColumns;
			if (verticalAlign == VerticalAlign.JUSTIFY)
				realCellHeight = (layoutView.minVerticalScrollPosition - paddingTop - paddingBottom - (realCellRows - 1) * gap) / realCellRows;
			
			// 设置细胞视图的实际大小
			layoutView.maxHorizontalScrollPosition = paddingLeft + paddingRight + realCellWidth * realCellColumns + (realCellColumns - 1) * gap;
			layoutView.maxVerticalScrollPosition = paddingTop + paddingBottom + realCellHeight * realCellRows + (realCellRows - 1) * gap;
			
			// 设置细胞元素 原点
			if (horizontalAlign == HorizontalAlign.LEFT ||
				horizontalAlign == HorizontalAlign.JUSTIFY)
				realCellOriginPoint.x = paddingLeft;
			else if (horizontalAlign == HorizontalAlign.CENTER)
				realCellOriginPoint.x = (layoutView.maxHorizontalScrollPosition - realCellWidth * realCellColumns - (realCellColumns - 1) * gap) / 2;
			else if (horizontalAlign == HorizontalAlign.RIGHT)
				realCellOriginPoint.x = layoutView..maxHorizontalScrollPosition - realCellWidth * realCellColumns - (realCellColumns - 1) * gap - paddingRight;
			if (verticalAlign == VerticalAlign.TOP ||
				verticalAlign == VerticalAlign.JUSTIFY)
				realCellOriginPoint.y = paddingTop
			else if (verticalAlign == VerticalAlign.MIDDLE)
				realCellOriginPoint.y = (layoutView.maxVerticalScrollPosition - realCellHeight * realCellRows - (realCellRows - 1) * gap) / 2;
			else if (verticalAlign == VerticalAlign.BOTTOM)
				realCellOriginPoint.y = layoutView.maxVerticalScrollPosition - realCellHeight * realCellRows - (realCellRows - 1) * gap - paddingBottom;
		}
		
		public function updateLayout():void
		{
			realCellShowPoint.x = layoutView.horizontalScrollPosition - layoutView.minHorizontalScrollPosition;
			realCellShowPoint.y = layoutView.verticalScrollPosition - layoutView.minVerticalScrollPosition;
			
			var cell:IUIComponent;
			var cellColumn:int;
			var cellRow:int;
			for (var i:int = 0; i < realCellCount; i++)
			{
				cell = layoutView.getChildAt(i) as IUIComponent;
				cellColumn = i % realCellColumns;
				cellRow = Math.floor(i / realCellColumns);
				cell.x = cellColumn * (realCellWidth + gap) + realCellOriginPoint.x - realCellShowPoint.x;
				cell.y= cellRow * (realCellHeight + gap) + realCellOriginPoint.y - realCellShowPoint.y;
				if (horizontalAlign == HorizontalAlign.JUSTIFY)
					cell.setSizeWithoutDispatchResizeEvent(realCellWidth);
				if (verticalAlign == VerticalAlign.JUSTIFY)
					cell.setSizeWithoutDispatchResizeEvent(NaN, realCellHeight);
			}
		}
		
		public function clearLayout():void
		{
			// do nothings
		}
		
	}
}