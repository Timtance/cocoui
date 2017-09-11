package coco.helper
{
	import flash.events.MouseEvent;
	
	import coco.component.IItemRenderer;
	import coco.core.coco;
	import coco.event.ItemRendererEvent;
	import coco.layout.IVirtualLayoutView;
	
	/**
	 * 虚拟布局元素选择器
	 * 
	 * @author coco
	 */	
	public class SelectHelper implements ISelectHelper
	{
		public function SelectHelper()
		{
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		//------------------------------------------
		// cellSelected 
		//------------------------------------------
		
		/**
		 * 当前选中的细胞 
		 */		
		private var cellSelected:IItemRenderer;
		
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
			if (!_virtualLayoutView == value) return;
			
			// 有旧的视图 卸载旧的视图的监听器
			if (_virtualLayoutView)
				uninstallListener();
			
			_virtualLayoutView = value;
			installListener();
		}
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 更新选中状态
		 */		
		public function updateSelect():void
		{
			if (!virtualLayoutView) return;
			
			var cellLen:int = virtualLayoutView.numChildren;
			var cell:IItemRenderer;
			for (var i:int = 0; i < cellLen; i++)
			{
				cell = virtualLayoutView.getChildAt(i) as IItemRenderer;
				if (cell && cell.visible) // 细胞存在 且  细胞可视（代表细胞有效） 才会设置细胞选中状态
				{
					if (virtualLayoutView.selectedIndices.indexOf(cell.index) == -1)
						cell.selected = false;
					else
					{
						cell.selected = true;
						cellSelected = cell;
					}
				}
			}
		}
		
		private function installListener():void
		{
			if (!virtualLayoutView) return;
			
			virtualLayoutView.addEventListener(ItemRendererEvent.ADDED, cell_addedHandler);
			virtualLayoutView.addEventListener(ItemRendererEvent.REMOVED, cell_removedHandler);
		}
		
		private function uninstallListener():void
		{
			if (!virtualLayoutView) return;
			
			virtualLayoutView.removeEventListener(ItemRendererEvent.ADDED, cell_addedHandler);
			virtualLayoutView.removeEventListener(ItemRendererEvent.REMOVED, cell_removedHandler);
		}
		
		
		private function cell_addedHandler(e:ItemRendererEvent):void
		{
			// 渲染器被添加 开始选中监听
			e.itemRenderer.addEventListener(ItemRendererEvent.SELECTED, cell_selectedHandler);
			e.itemRenderer.addEventListener(MouseEvent.CLICK, cell_clickHandler);
			
			// 细胞被添加的时候 应该计算 此细胞是否被选中
			e.itemRenderer.selected = virtualLayoutView.selectedIndices.indexOf(e.itemRenderer.index) == -1 ? false : true;
			
			if (e.itemRenderer.selected)
				cellSelected = e.itemRenderer;
		}
		
		private function cell_removedHandler(e:ItemRendererEvent):void
		{
			// 渲染器被移除 取消选中监听
			e.itemRenderer.removeEventListener(ItemRendererEvent.SELECTED, cell_selectedHandler);
			e.itemRenderer.removeEventListener(MouseEvent.CLICK, cell_clickHandler);
			
			// 细胞被移除的时候 细胞取消选中
			e.itemRenderer.selected = false;
		}
		
		private function cell_clickHandler(e:MouseEvent):void
		{
			// 渲染器被点击  向渲染器派发个正在选中事件
			// 如果渲染器不能不选中  请阻止这个事件
			var itemRenderer:IItemRenderer = e.currentTarget as IItemRenderer;
			if (itemRenderer)
			{
				var itemRendererEvent:ItemRendererEvent = new ItemRendererEvent(ItemRendererEvent.SELECTED, false, true);
				itemRendererEvent.itemRenderer = itemRenderer;
				itemRenderer.dispatchEvent(itemRendererEvent);
			}
		}
		
		private function cell_selectedHandler(e:ItemRendererEvent):void
		{
			if (e.isDefaultPrevented())
				return;
			
			// 细胞被选中
			var cell:IItemRenderer = e.itemRenderer;
			
			// 删除细胞索引 
			var deleteFlag:Boolean = deleteSelectedIndex(cell.index);
			if (deleteFlag) 
			{
				// 如果删除成功 表示改索引已经被选中 应该做取消选中操作
				virtualLayoutView.coco::_selectedIndex = virtualLayoutView.selectedIndices.length > 0 ? virtualLayoutView.selectedIndices[0] : -1;
				cell.selected = false;
				cellSelected = null;
			}
			else 
			{
				// 不允许多选 先清空索引组 再添加
				if (!virtualLayoutView.allowMultipleSelection)
				{
					if (cellSelected)
						cellSelected.selected = false;
					
					virtualLayoutView.selectedIndices.splice(0, virtualLayoutView.selectedIndices.length);
				}
				
				virtualLayoutView.selectedIndices.push(cell.index);
				virtualLayoutView.coco::_selectedIndex = cell.index; 
				cell.selected = true;
				cellSelected = cell;
			}
			
			virtualLayoutView.itemRendererSelected(cellSelected);
		}
		
		/**
		 * 删除选中的索引
		 * 
		 * 删除成功 返回 true
		 * 删除失败 返回 false
		 * 
		 * @param index
		 * @return 
		 */		
		private function deleteSelectedIndex(index:int):Boolean
		{
			var indexLen:int = virtualLayoutView.selectedIndices.length;
			for (var i:int = indexLen - 1; i >= 0; i--)
			{
				if (virtualLayoutView.selectedIndices[i] == index)
				{
					virtualLayoutView.selectedIndices.splice(i, 1);
					return true;
				}
			}
			
			return false;
		}
		
	}
}