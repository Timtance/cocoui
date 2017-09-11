package coco.layout
{
	import flash.geom.Point;
	
	import coco.component.HorizontalAlign;
	import coco.component.IItemRenderer;
	import coco.component.VerticalAlign;
	
	
	/**
	 *
	 * 列表页虚拟布局 
	 * 
	 * 以页的方式进行布局
	 *  
	 * @author coco
	 * 
	 */	
	public class ListPageVirtualLayout extends ListVirtualLayout
	{
		public function ListPageVirtualLayout()
		{
			super();
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		//------------------------------------------
		// virtualLayoutView 
		//------------------------------------------
		
		override public function set virtualLayoutView(value:IVirtualLayoutView):void
		{
			// ListPageVirtualLayout 覆盖此方法 因为默认打开VirtualLayoutView的pageScrollEnabled
			if (super.virtualLayoutView == value) return;
			super.virtualLayoutView = value;
			virtualLayoutView.pageScrollEnabled = true;
		}
		
		//------------------------------------------
		// itemRendererPageCount 
		//------------------------------------------
		
		private var _pageCount:int = 0;
		
		/**
		 * 总的页数 
		 */		
		public function get pageCount():int
		{
			return _pageCount;
		}
		
		//------------------------------------------
		// itemRendererPage 
		//------------------------------------------
		
		private var _page:int = 1;
		
		/**
		 * 当前页  1 － 最大页数
		 */		
		public function get page():int
		{
			return _page;
		}
		
		public function set page(value:int):void
		{
			// only read
		}
		
		
		//------------------------------------------
		// pageCount 
		//------------------------------------------
		
		
		private var _pageColumnCount:int = 0;
		
		/**
		 * 细胞页的列数 
		 */
		public function get pageColumnCount():int
		{
			return _pageColumnCount;
		}
		
		/**
		 * @private
		 */
		public function set pageColumnCount(value:int):void
		{
			if (_pageColumnCount == value) return;
			_pageColumnCount = value;
			
			if (virtualLayoutView)
				virtualLayoutView.invalidateDisplayList();
		}
		
		
		//------------------------------------------
		// pageCount 
		//------------------------------------------
		
		
		private var _pageRowCount:int = 0;
		
		/**
		 * 细胞页的行数 
		 */
		public function get pageRowCount():int
		{
			return _pageRowCount;
		}
		
		/**
		 * @private
		 */
		public function set pageRowCount(value:int):void
		{
			if (_pageRowCount == value) return;
			_pageRowCount = value;
			
			if (virtualLayoutView)
				virtualLayoutView.invalidateDisplayList();
		}
		
		
		//------------------------------------------
		// pageAutoFill 
		//------------------------------------------
		
		private var _pageAutoFill:Boolean = false;

		/**
		 * 页面自动填充满  如果当前页面的实际列数 行数不够填满 将会自动填满
		 */		
		public function get pageAutoFill():Boolean
		{
			return _pageAutoFill;
		}

		public function set pageAutoFill(value:Boolean):void
		{
			if (_pageAutoFill == value) return;
			_pageAutoFill = value;
			if (virtualLayoutView)
				virtualLayoutView.invalidateDisplayList();
		}
		
		
		/**
		 * 实际的细胞页数 
		 */		
		private var realCellPageCount:int;
		/**
		 * 每页的细胞数 
		 */		
		private var realCellPageCellCount:int;
		/**
		 * 实际页的列数
		 */		
		private var realCellPageColumnCount:int; 
		/**
		 * 实际页的行数
		 */		
		private var realCellPageRowCount:int; 
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 初始化布局
		 * 
		 * 确定细胞布局的
		 * 	细胞个数
		 *  细胞列数
		 *  细胞行数
		 *  细胞高度
		 *  细胞宽度
		 *  细胞布局高度
		 *  细胞布局宽度
		 *  细胞布局起点
		 */		
		override public function initVirtualLayout():void
		{
			// 在 CellPageLayout 中 
			// itemRendererColumnCount 代表每页的细胞的列数
			// itemRendererRowCount 代表每页的细胞的行数
			
			// 获取细胞元素的实际数目 实际的细胞列数 实际的细胞行数
			realCellCount = virtualLayoutView.dataProvider ? virtualLayoutView.dataProvider.length : 0;
			// 设置每页的细胞行数 列数
			if (virtualLayoutView.itemRendererColumnCount > 0) // 如果细胞列数大于0  按列数来排序
				realCellColumns = virtualLayoutView.itemRendererColumnCount;
			else
				realCellColumns = 1;
			
			if (virtualLayoutView.itemRendererRowCount > 0) //  按行数来排序
				realCellRows = virtualLayoutView.itemRendererRowCount;
			else
				realCellRows = 1;
			
			// 实际的每页细胞数目
			realCellPageCellCount = realCellRows * realCellColumns;
			
			// 实际的细胞页数 如果实际的页数＝0  则默认为1页
			realCellPageCount = Math.ceil(realCellCount / realCellPageCellCount);
			if (realCellPageCount < 1)
				realCellPageCount = 1;
			
			_pageCount = realCellPageCount;
			// 设置页的列数 行数
			if (pageColumnCount > 0)
			{
				realCellPageColumnCount = pageColumnCount;
				realCellPageRowCount = Math.ceil( realCellPageCount / realCellPageColumnCount);
			}
			else if (pageRowCount > 0)
			{
				realCellPageRowCount = pageRowCount;
				realCellPageColumnCount = Math.ceil(realCellPageCount / realCellPageRowCount);
			}
			else
			{
				realCellPageColumnCount = 1;
				realCellPageRowCount = realCellPageCount;
			}
			
//			trace("页数", realCellPageCount, "页列数", realCellPageColumnCount, "页行数", realCellPageRowCount, "细胞列数", realCellColumns, "细胞行数", realCellRows);
			
			// 获取细胞元素的 实际的细胞高度 宽度
			realCellWidth = realCellHeight = 40;
			if (virtualLayoutView.horizontalAlign == HorizontalAlign.JUSTIFY)
				realCellWidth =  (virtualLayoutView.minHorizontalScrollPosition - virtualLayoutView.paddingLeft - virtualLayoutView.paddingRight - (realCellColumns - 1) * virtualLayoutView.gap) / realCellColumns;
			if (virtualLayoutView.verticalAlign == VerticalAlign.JUSTIFY)
				realCellHeight = (virtualLayoutView.minVerticalScrollPosition - virtualLayoutView.paddingTop - virtualLayoutView.paddingBottom - (realCellRows - 1) * virtualLayoutView.gap) / realCellRows;
			
			// 如果用户手动设置细胞元素的大小 则细胞的实际大小全部为用户设置的大小
			if (!isNaN(virtualLayoutView.itemRendererWidth))
				realCellWidth = virtualLayoutView.itemRendererWidth;
			if (!isNaN(virtualLayoutView.itemRendererHeight))
				realCellHeight = virtualLayoutView.itemRendererHeight;
			
			// 设置细胞元素 原点
			if (virtualLayoutView.horizontalAlign == HorizontalAlign.LEFT ||
				virtualLayoutView.horizontalAlign == HorizontalAlign.JUSTIFY)
				realCellOriginPoint.x = virtualLayoutView.paddingLeft;
			else if (virtualLayoutView.horizontalAlign == HorizontalAlign.CENTER)
				realCellOriginPoint.x = (virtualLayoutView.minHorizontalScrollPosition - realCellWidth * realCellColumns - (realCellColumns - 1) * virtualLayoutView.gap) / 2;
			else if (virtualLayoutView.horizontalAlign == HorizontalAlign.RIGHT)
				realCellOriginPoint.x = virtualLayoutView.minHorizontalScrollPosition - realCellWidth * realCellColumns - (realCellColumns - 1) * virtualLayoutView.gap - virtualLayoutView.paddingRight;
			
			if (virtualLayoutView.verticalAlign == VerticalAlign.TOP ||
				virtualLayoutView.verticalAlign == VerticalAlign.JUSTIFY)
				realCellOriginPoint.y = virtualLayoutView.paddingTop
			else if (virtualLayoutView.verticalAlign == VerticalAlign.MIDDLE)
				realCellOriginPoint.y = (virtualLayoutView.minVerticalScrollPosition - realCellHeight * realCellRows - (realCellRows - 1) * virtualLayoutView.gap) / 2;
			else if (virtualLayoutView.verticalAlign == VerticalAlign.BOTTOM)
				realCellOriginPoint.y = virtualLayoutView.minVerticalScrollPosition - realCellHeight * realCellRows - (realCellRows - 1) * virtualLayoutView.gap - virtualLayoutView.paddingBottom;
			
			
			virtualLayoutView.maxHorizontalScrollPosition = realCellPageColumnCount * virtualLayoutView.minHorizontalScrollPosition;
			virtualLayoutView.maxVerticalScrollPosition = realCellPageRowCount * virtualLayoutView.minVerticalScrollPosition;
		}
		
		override public function updateVirtualLayout():void
		{
			// 更新当前页
			_page = getPositionPage(virtualLayoutView.horizontalScrollPosition - 1, virtualLayoutView.verticalScrollPosition - 1);
			
			// should do clear
			if (!virtualLayoutView.dataProvider) return;
			
			var itemRendererShowIndices:Vector.<int> = getCellShowIndices();
			
			var itemRendererLen:int = virtualLayoutView.numChildren;
			var itemRenderer:IItemRenderer;
			var itemRendererPosition:Point;
			for (var i:int = 0; i < itemRendererLen; i++)
			{
				itemRenderer = virtualLayoutView.getChildAt(i) as IItemRenderer;
				// 只有可视的细胞是有效的  不可视的细胞都是缓存的
				if (itemRenderer.visible)
				{
					// 看这个细胞在不在 要显示的索引中
					var itemRendererExistIndex:int = itemRendererShowIndices.indexOf(itemRenderer.index);
					if (itemRendererExistIndex == -1)
					{
						// 此细胞不在显示索引中  移除并缓存细胞
						realCellCache.push(itemRenderer); // 细胞放到缓存队列
						itemRenderer.visible = false; // 不显示
						
						// 告诉视图 渲染器被移除
						virtualLayoutView.itemRendererRemoved(itemRenderer);
					}
					else
					{
						// 此细胞在显示索引中 更新细胞
						itemRendererPosition = getCellPosition(itemRenderer.index);
						itemRenderer.data = virtualLayoutView.dataProvider[itemRenderer.index];
						itemRenderer.labelField = virtualLayoutView.labelField;
						itemRenderer.x = itemRendererPosition.x - realCellShowPoint.x;
						itemRenderer.y = itemRendererPosition.y - realCellShowPoint.y;
						itemRenderer.width = realCellWidth;
						itemRenderer.height = realCellHeight;
						
						// 删除 已经显示细胞的索引
						itemRendererShowIndices.splice(itemRendererExistIndex, 1);
					}
				}
			}
			
			// 这个时候 itemRendererShowIndices 中的索引都是需要去显示的细胞索引
			for each (var index:int in itemRendererShowIndices)
			{
				itemRenderer = getCell();
				itemRenderer.index = index;
				itemRenderer.data = virtualLayoutView.dataProvider[index];
				itemRenderer.labelField = virtualLayoutView.labelField;
				itemRendererPosition = getCellPosition(itemRenderer.index);
				itemRenderer.x = itemRendererPosition.x - realCellShowPoint.x;
				itemRenderer.y = itemRendererPosition.y - realCellShowPoint.y;
				itemRenderer.width = realCellWidth;
				itemRenderer.height = realCellHeight;
				
				// 告诉视图渲染器被添加
				virtualLayoutView.itemRendererAdded(itemRenderer);
			}
		}
		
		
		/**
		 * 获取显示的细胞元素的位置信息
		 */		
		override protected function getCellShowIndices():Vector.<int>
		{
			super.getCellShowIndices();
			var showCellIndices:Vector.<int> = new Vector.<int>();
			
			realCellShowPoint.x = virtualLayoutView.horizontalScrollPosition - virtualLayoutView.minHorizontalScrollPosition;
			realCellShowPoint.y = virtualLayoutView.verticalScrollPosition - virtualLayoutView.minVerticalScrollPosition;
			
			var topLeftPage:int = getPositionPage(realCellShowPoint.x, realCellShowPoint.y);
			var topRightPage:int = getPositionPage(realCellShowPoint.x + virtualLayoutView.minHorizontalScrollPosition - 1, realCellShowPoint.y);
			var bottomLeftPage:int = getPositionPage(realCellShowPoint.x, realCellShowPoint.y + virtualLayoutView.minVerticalScrollPosition - 1);
			var bottomRightPage:int = getPositionPage(realCellShowPoint.x + virtualLayoutView.minHorizontalScrollPosition - 1, 
				realCellShowPoint.y + virtualLayoutView.minVerticalScrollPosition - 1);
			
			var pageOlds:Vector.<int> = new Vector.<int>();
			showCellIndices = getCellPageShowIndices(topLeftPage);
			pageOlds.push(topLeftPage);
			
			if (pageOlds.indexOf(topRightPage) == -1)
			{
				showCellIndices = showCellIndices.concat(getCellPageShowIndices(topRightPage));
				pageOlds.push(topRightPage);
			}
			
			if (pageOlds.indexOf(bottomLeftPage) == -1)
			{
				showCellIndices = showCellIndices.concat(getCellPageShowIndices(bottomLeftPage));
				pageOlds.push(bottomLeftPage);
			}
			
			if (pageOlds.indexOf(bottomRightPage) == -1)
			{
				showCellIndices = showCellIndices.concat(getCellPageShowIndices(bottomRightPage));
				pageOlds.push(bottomRightPage);
			}
			
			return showCellIndices;
		}
		
		private function getCellPageShowIndices(page:int):Vector.<int>
		{
			var showCellIndices:Vector.<int> = new Vector.<int>();
			if (page < 1 || page > realCellPageCount) return showCellIndices;
			
			var itemRendererIndex:int = realCellPageCellCount * (page - 1);
			var itemRendererPosition:Point;
			for (var i:int = 0; i < realCellPageCellCount; i++)
			{
				itemRendererPosition = getCellPosition(itemRendererIndex);
				
				if ((itemRendererPosition.y + realCellHeight) > realCellShowPoint.y &&
					itemRendererPosition.y < virtualLayoutView.verticalScrollPosition &&
					(itemRendererPosition.x + realCellWidth) > realCellShowPoint.x &&
					itemRendererPosition.x < virtualLayoutView.horizontalScrollPosition)
				{
					// 如果索引在可视范围类  或者能够自动填充
					if (pageAutoFill || itemRendererIndex < realCellCount)
						showCellIndices.push(itemRendererIndex);
				}
				
				itemRendererIndex++;
			}
			
			return showCellIndices;
		}
		
		private function getCellPosition(itemRendererIndex:int):Point
		{
			var point:Point = new Point();
			var pageCurrent:int = Math.floor(itemRendererIndex / realCellPageCellCount) + 1;  
			var pageColumn:int = (pageCurrent - 1) % realCellPageColumnCount + 1;
			var pageRow:int = Math.ceil(pageCurrent / realCellPageColumnCount);
			point.x = realCellOriginPoint.x + (itemRendererIndex % realCellPageCellCount % realCellColumns) * (realCellWidth + virtualLayoutView.gap) + 
				(pageColumn - 1) * virtualLayoutView.minHorizontalScrollPosition;
			point.y = realCellOriginPoint.y + Math.floor(itemRendererIndex % realCellPageCellCount / realCellColumns) * (realCellHeight + virtualLayoutView.gap) + 
				(pageRow - 1) * virtualLayoutView.minVerticalScrollPosition;
			return point;
		}
		
		/**
		 * 根据位置来获取 位置所处的页
		 * 
		 * @param px
		 * @param py
		 * @return 
		 * 
		 */		
		private function getPositionPage(px:Number, py:Number):int
		{
			var pointPageColumn:int = Math.floor(px / virtualLayoutView.minHorizontalScrollPosition) + 1;
			if (pointPageColumn > realCellPageColumnCount)
				pointPageColumn = realCellPageColumnCount;
			var pointPageRow:int = Math.floor(py / virtualLayoutView.minVerticalScrollPosition) + 1;
			if (pointPageRow > realCellPageRowCount)
				pointPageRow = realCellPageRowCount;
			var pointPage:int = (pointPageRow - 1) * realCellPageColumnCount + pointPageColumn;
			return  pointPage;
		}
		
	}
}