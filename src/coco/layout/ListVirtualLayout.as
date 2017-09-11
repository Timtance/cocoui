package coco.layout
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import coco.component.HorizontalAlign;
	import coco.component.IItemRenderer;
	import coco.component.VerticalAlign;
	import coco.core.coco;
	
	
	use namespace coco;
	
	/**
	 * 
	 * 列表虚拟布局
	 * 
	 * 此布局基本支持大部分的排序方式
	 * 
	 * @author Coco
	 */	
	public class ListVirtualLayout implements IVirtualLayout
	{
		public function ListVirtualLayout()
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
		
		private var _virtualLayoutView:IVirtualLayoutView;
		
		public function get virtualLayoutView():IVirtualLayoutView
		{
			return _virtualLayoutView;
		}
		
		public function set virtualLayoutView(value:IVirtualLayoutView):void
		{
			if (_virtualLayoutView == value) return;
			_virtualLayoutView = value;
		}
		
		protected var realCellCount:int;
		protected var realCellColumns:int;
		protected var realCellRows:int;
		protected var realCellWidth:Number = 0;
		protected var realCellHeight:Number = 0;
		protected var realCellOriginPoint:Point = new Point(); // 细胞原点坐标 用于虚拟布局 细胞布局的起点坐标
		protected var realCellShowPoint:Point = new Point(); // 细胞显示最大点
		protected var realCellCache:Vector.<IItemRenderer> = new Vector.<IItemRenderer>();
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Methods  虚拟布局
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
		public function initVirtualLayout():void
		{
			// 获取细胞元素的实际数目 实际的细胞列数 实际的细胞行数
			realCellCount = virtualLayoutView.dataProvider ? virtualLayoutView.dataProvider.length : 0;
			
			if (virtualLayoutView.itemRendererColumnCount > 0) // 如果细胞列数大于0  按列数来排序
			{
				realCellColumns = virtualLayoutView.itemRendererColumnCount;
				realCellRows = Math.ceil(realCellCount / realCellColumns);  // 细胞行数
			}
			else if (virtualLayoutView.itemRendererRowCount > 0) //  按行数来排序
			{
				realCellRows = virtualLayoutView.itemRendererRowCount;
				realCellColumns = Math.ceil(realCellCount / realCellRows);  // 细胞行数
			}
			else
			{
				realCellColumns = 1;
				realCellRows = realCellCount;
			}
			
			// 获取细胞元素的 实际的细胞高度 宽度
			realCellWidth = 100;
			realCellHeight = 30;
			if (virtualLayoutView.horizontalAlign == HorizontalAlign.JUSTIFY)
				realCellWidth =  (virtualLayoutView.minHorizontalScrollPosition - virtualLayoutView.paddingLeft - virtualLayoutView.paddingRight - (realCellColumns - 1) * virtualLayoutView.gap) / realCellColumns;
			if (virtualLayoutView.verticalAlign == VerticalAlign.JUSTIFY)
				realCellHeight = (virtualLayoutView.minVerticalScrollPosition - virtualLayoutView.paddingTop - virtualLayoutView.paddingBottom - (realCellRows - 1) * virtualLayoutView.gap) / realCellRows;
			
			// 如果用户手动设置细胞元素的大小 则细胞的实际大小全部为用户设置的大小
			if (!isNaN(virtualLayoutView.itemRendererWidth))
				realCellWidth = virtualLayoutView.itemRendererWidth;
			if (!isNaN(virtualLayoutView.itemRendererHeight))
				realCellHeight = virtualLayoutView.itemRendererHeight;
			
			// 设置细胞视图的实际大小
			virtualLayoutView.maxHorizontalScrollPosition = virtualLayoutView.paddingLeft + virtualLayoutView.paddingRight + realCellWidth * realCellColumns + (realCellColumns - 1) * virtualLayoutView.gap;
			virtualLayoutView.maxVerticalScrollPosition = virtualLayoutView.paddingTop + virtualLayoutView.paddingBottom + realCellHeight * realCellRows + (realCellRows - 1) * virtualLayoutView.gap;
			
			// 设置细胞元素 原点
			if (virtualLayoutView.horizontalAlign == HorizontalAlign.LEFT ||
				virtualLayoutView.horizontalAlign == HorizontalAlign.JUSTIFY)
				realCellOriginPoint.x = virtualLayoutView.paddingLeft;
			else if (virtualLayoutView.horizontalAlign == HorizontalAlign.CENTER)
				realCellOriginPoint.x = (virtualLayoutView.maxHorizontalScrollPosition - realCellWidth * realCellColumns - (realCellColumns - 1) * virtualLayoutView.gap) / 2;
			else if (virtualLayoutView.horizontalAlign == HorizontalAlign.RIGHT)
				realCellOriginPoint.x = virtualLayoutView.maxHorizontalScrollPosition - realCellWidth * realCellColumns - (realCellColumns - 1) * virtualLayoutView.gap - virtualLayoutView.paddingRight;
			
			if (virtualLayoutView.verticalAlign == VerticalAlign.TOP ||
				virtualLayoutView.verticalAlign == VerticalAlign.JUSTIFY)
				realCellOriginPoint.y = virtualLayoutView.paddingTop
			else if (virtualLayoutView.verticalAlign == VerticalAlign.MIDDLE)
				realCellOriginPoint.y = (virtualLayoutView.maxVerticalScrollPosition - realCellHeight * realCellRows - (realCellRows - 1) * virtualLayoutView.gap) / 2;
			else if (virtualLayoutView.verticalAlign == VerticalAlign.BOTTOM)
				realCellOriginPoint.y = virtualLayoutView.maxVerticalScrollPosition - realCellHeight * realCellRows - (realCellRows - 1) * virtualLayoutView.gap - virtualLayoutView.paddingBottom;
		}
		
		/**
		 * 清理布局
		 */		
		public function clearVirtualLayout():void
		{
			// 清空 缓存的细胞
			realCellCache.splice(0, realCellCache.length);
			
			// 清空 细胞视图
			if (virtualLayoutView)
				virtualLayoutView.removeAllChild();
		}
		
		/**
		 * 更新布局
		 */		
		public function updateVirtualLayout():void
		{
			// should do clear
			if (!virtualLayoutView.dataProvider) return;
			
			var itemRendererShowIndices:Vector.<int> = getCellShowIndices();
			var itemRendererLen:int = virtualLayoutView.numChildren;
			var itemRenderer:IItemRenderer;
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
						itemRenderer.data = virtualLayoutView.dataProvider[itemRenderer.index];
						itemRenderer.labelField = virtualLayoutView.labelField;
						itemRenderer.x = realCellOriginPoint.x + (itemRenderer.index % realCellColumns) * (realCellWidth + virtualLayoutView.gap) - realCellShowPoint.x;
						itemRenderer.y = realCellOriginPoint.y + Math.floor(itemRenderer.index / realCellColumns) * (realCellHeight + virtualLayoutView.gap) - realCellShowPoint.y;
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
				itemRenderer.x = realCellOriginPoint.x + (index % realCellColumns) * (realCellWidth + virtualLayoutView.gap) - realCellShowPoint.x;
				itemRenderer.y = realCellOriginPoint.y + Math.floor(index / realCellColumns) * (realCellHeight + virtualLayoutView.gap) - realCellShowPoint.y;
				itemRenderer.width = realCellWidth;
				itemRenderer.height = realCellHeight;
				
				// 告诉视图渲染器被添加
				virtualLayoutView.itemRendererAdded(itemRenderer);
			}
		}
		
		/**
		 * 获取显示的细胞元素的位置信息
		 */		
		protected function getCellShowIndices():Vector.<int>
		{
			var showCellIndices:Vector.<int> = new Vector.<int>();
			realCellShowPoint.x = virtualLayoutView.horizontalScrollPosition - virtualLayoutView.minHorizontalScrollPosition;
			realCellShowPoint.y = virtualLayoutView.verticalScrollPosition - virtualLayoutView.minVerticalScrollPosition;
			
			var itemRendererShowX:Number = realCellShowPoint.x - realCellOriginPoint.x;
			var itemRendererShowY:Number = realCellShowPoint.y - realCellOriginPoint.y;
			
			//  topLeftColumn            topRightColumn
			//  topLeftRow
			//
			//
			//	bottomLeftRow        
			
			// topLeftIndex
			var topLeftColumn:int = getCellColumn(Math.ceil(itemRendererShowX / (realCellWidth + virtualLayoutView.gap)));
			var topLeftRow:int = getCellRow(Math.ceil(itemRendererShowY / (realCellHeight + virtualLayoutView.gap)));
			
			// topRightColumn
			var topRightColumn:int = getCellColumn(Math.ceil((itemRendererShowX + virtualLayoutView.minHorizontalScrollPosition) / (realCellWidth + virtualLayoutView.gap))); 
			
			// bottomLeftRow
			var bottomLeftRow:int = getCellRow(Math.ceil((itemRendererShowY + virtualLayoutView.minVerticalScrollPosition) / (realCellHeight + virtualLayoutView.gap)));
			
			var columnOffset:int = topRightColumn - topLeftColumn + 1;
			var rowOffset:int = bottomLeftRow - topLeftRow + 1;
			var rowIndex:int;
			var columnIndex:int;
			for (var row:int = 0; row < rowOffset; row++)
			{
				rowIndex = topLeftColumn - 1 + (topLeftRow + row - 1) * realCellColumns;
				for (var column:int = 0; column < columnOffset; column++)
				{
					columnIndex = rowIndex + column;
					if (columnIndex < realCellCount) // 防止索引超出范围
						showCellIndices.push(columnIndex);
				}
			}
			return showCellIndices;
		}
		
		protected function getCell():IItemRenderer
		{
			var itemRenderer:IItemRenderer;
			if (realCellCache.length > 0)
			{
				itemRenderer = realCellCache.pop();
				itemRenderer.visible = true;
			}
			else
			{
				itemRenderer = new virtualLayoutView.itemRendererClass() as IItemRenderer;
				virtualLayoutView.addChild(itemRenderer as DisplayObject);
			}
			
			return itemRenderer;
		}
		
		protected function getCellColumn(itemRendererColumn:int):int
		{
			if (itemRendererColumn < 1) 
				return 1;
			else if (itemRendererColumn > realCellColumns) 
				return realCellColumns;
			else 
				return itemRendererColumn;
		}
		
		protected function getCellRow(itemRendererRow:int):int
		{
			if (itemRendererRow < 1) 
				return 1;
			else if (itemRendererRow > realCellRows) 
				return realCellRows;
			else 
				return itemRendererRow;
			
		}
		
	}
}