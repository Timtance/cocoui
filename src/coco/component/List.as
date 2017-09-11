package coco.component
{
	import coco.core.coco;
	import coco.event.ItemRendererEvent;
	import coco.event.UIEvent;
	import coco.helper.ISelectHelper;
	import coco.helper.SelectHelper;
	import coco.layout.IVirtualLayout;
	import coco.layout.IVirtualLayoutView;
	import coco.layout.ListVirtualLayout;
	
	use namespace coco;
	
	/**
	 * 细胞元素被添加的时候派发
	 * 正常是由ICell dispatchCellAddedEvent派发
	 */	
	[Event(name="itemRenderer_added", type="coco.event.ItemRendererEvent")]
	
	/**
	 * 细胞元素被移除的时候派发
	 * 正常是由ICell dispatchCellRemovedEvent派发
	 */	
	[Event(name="itemRenderer_removed", type="coco.event.ItemRendererEvent")]
	
	/**
	 * 索引发送改变的时候派发
	 */	
	[Event(name="ui_change", type="coco.event.UIEvent")]
	
	/**
	 *
	 * 支持布局的视图组件
	 *  
	 * @author coco
	 * 
	 */	
	public class List extends ScrollView implements IVirtualLayoutView
	{
		public function List()
		{
			super();
			
			horizontalScrollEnabled = false;
		}
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		//------------------------------------------
		// selecter 
		//------------------------------------------
		
		private var _selecter:ISelectHelper = new SelectHelper();
		
		/**
		 * 细胞视图辅助 用于细胞元素的操作 如 选中 多选等 
		 */
		public function get selecter():ISelectHelper
		{
			return _selecter;
		}
		
		/**
		 * @private
		 */
		public function set selecter(value:ISelectHelper):void
		{
			if (_selecter == value) return;
			
			// clear old Helper
			if (_selecter)
			{
				_selecter.virtualLayoutView = null;
				_selecter = null;
			}
			
			_selecter = value;
			invalidateProperties();
		}
		
		
		//------------------------------------------
		// layout 
		//------------------------------------------
		
		private var _virtualLayout:IVirtualLayout = new ListVirtualLayout();
		
		/**
		 *
		 * 默认布局为VirtualLayout
		 *  
		 * @return 
		 * 
		 */		
		public function get virtualLayout():IVirtualLayout
		{
			return _virtualLayout;
		}
		
		public function set virtualLayout(value:IVirtualLayout):void
		{
			if (_virtualLayout == value) return;
			
			// clear old virtualLayout
			if (_virtualLayout)
			{
				_virtualLayout.virtualLayoutView = null;
				_virtualLayout = null;
			}
			
			_virtualLayout = value;
			invalidateProperties();
			invalidateDisplayList();
		}
		
		//------------------------------------------
		// itemRendererWidth
		//------------------------------------------
		
		private var _itemRendererWidth:Number = NaN;
		
		public function get itemRendererWidth():Number
		{
			return _itemRendererWidth;
		}
		
		public function set itemRendererWidth(value:Number):void
		{
			if (_itemRendererWidth == value) return;
			_itemRendererWidth = value;
			invalidateDisplayList();
		}
		
		
		//------------------------------------------
		// itemRendererHeight
		//------------------------------------------
		
		private var _itemRendererHeight:Number = NaN;
		
		public function get itemRendererHeight():Number
		{
			return _itemRendererHeight;
		}
		
		public function set itemRendererHeight(value:Number):void
		{
			if (_itemRendererHeight == value) return;
			_itemRendererHeight = value;
			invalidateDisplayList();
		}
		
		
		//------------------------------------------
		// itemRendererColumnCount
		//------------------------------------------
		
		private var _itemRendererColumnCount:int = 0;
		
		public function get itemRendererColumnCount():int
		{
			return _itemRendererColumnCount;
		}
		
		public function set itemRendererColumnCount(value:int):void
		{
			if (_itemRendererColumnCount == value) return;
			_itemRendererColumnCount = value;
			invalidateDisplayList();
		}
		
		//------------------------------------------
		// itemRendererRowCount
		//------------------------------------------
		
		private var _itemRendererRowCount:int = 0;
		
		public function get itemRendererRowCount():int
		{
			return _itemRendererRowCount;
		}
		
		public function set itemRendererRowCount(value:int):void
		{
			if (_itemRendererRowCount == value) return;
			_itemRendererRowCount = value;
			invalidateDisplayList();
		}
		
		//------------------------------------------
		// horizontalScrollPosition
		//------------------------------------------
		
		override public function set horizontalScrollPosition(value:Number):void
		{
			value = Math.ceil(value);
			// 如果值的范围无效 将不会更新布局 提高性能
			if (super.horizontalScrollPosition == value) 
			{
				// 滚动的值相等 不需更新布局  但是可以更新滚动条 以便提示用户
				invalidateScrollBar();
				return;
			}
			super.horizontalScrollPosition = value;
			invalidateCellLayout();
		}
		
		
		//------------------------------------------
		// verticalScrollPosition
		//------------------------------------------
		
		override public function set verticalScrollPosition(value:Number):void
		{
			value = Math.ceil(value);
			// 如果值的范围无效 将不会更新布局 提高性能
			if (super.verticalScrollPosition == value) 
			{
				// 滚动的值相等 不需更新布局  但是可以更新滚动条 以便提示用户
				invalidateScrollBar();
				return;
			}
			super.verticalScrollPosition = value;
			invalidateCellLayout();
		}
		
		//------------------------------------------
		// itemRendererClass
		//------------------------------------------
		
		private var itemRendererClassChange:Boolean = false;
		private var _itemRendererClass:Class = DefaultItemRenderer;
		
		public function get itemRendererClass():Class
		{
			return _itemRendererClass;
		}
		
		public function set itemRendererClass(value:Class):void
		{
			if (_itemRendererClass == value) return;
			itemRendererClassChange = true;
			_itemRendererClass = value;
			invalidateDisplayList();
			invalidateCellSelecter();
		}
		
		//------------------------------------------
		// dataProvider
		//------------------------------------------
		
		private var _dataProvider:Array;
		
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:Array):void
		{
			_dataProvider = value;
			
			// V4.0.1 Support
			// 在赋值的时候 选中重置选中索引
			_selectedIndex = -1;
			_selectedIndices.splice(0, _selectedIndices.length);
			invalidateDisplayList();
			invalidateCellSelecter();
		}
		
		
		//------------------------------------------
		// labelField
		//------------------------------------------
		
		private var _labelField:String = "label";
		
		public function get labelField():String
		{
			return _labelField;
		}
		
		public function set labelField(value:String):void
		{
			if (_labelField == value) return;
			_labelField = value;
			invalidateDisplayList();
		}
		
		
		//------------------------------------------
		// selectedIndex
		//------------------------------------------
		
		coco var _selectedIndex:int = -1;
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			if (_selectedIndex == value) return;
			_selectedIndex = value;
			invalidateCellSelecter();
		}
		
		//------------------------------------------
		// selectedIndices
		//------------------------------------------
		
		private var _selectedIndices:Vector.<int> = new Vector.<int>();
		
		public function get selectedIndices():Vector.<int>
		{
			return _selectedIndices;
		}
		
		public function set selectedIndices(value:Vector.<int>):void
		{
			_selectedIndices = value;
			invalidateCellSelecter();
		}
		
		
		//------------------------------------------
		// allowMultipleSelection
		//------------------------------------------
		
		/**
		 * 是否允许多选 默认 false 
		 */		
		private var _allowMultipleSelection:Boolean = false;
		
		public function get allowMultipleSelection():Boolean
		{
			return _allowMultipleSelection;
		}
		
		public function set allowMultipleSelection(value:Boolean):void
		{
			if (_allowMultipleSelection == value) return;
			_allowMultipleSelection = value;
			invalidateCellSelecter();
		}
		
		
		//--------------------------------
		// selectedItem
		//--------------------------------
		
		/**
		 * 选中的对象
		 */	
		public function get selectedItem():Object
		{
			if (!dataProvider || 
				dataProvider.length == 0 ||
				selectedIndex < 0 ||
				selectedIndex >= dataProvider.length)
				return null;
			else
				return dataProvider[selectedIndex];
		}
		
		
		//------------------------------------------
		// selectedItems
		//------------------------------------------
		
		public function get selectedItems():Vector.<Object>
		{
			var result:Vector.<Object> = new Vector.<Object>();
			if (selectedIndices)
			{
				var count:int = selectedIndices.length;
				for (var i:int = 0; i < count; i++)
					result[i] = dataProvider[selectedIndices[i]];  
			}
			
			return result;
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
			invalidateDisplayList();
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
			invalidateDisplayList();
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
			invalidateDisplayList();
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
			invalidateDisplayList();
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
			invalidateDisplayList();
		}
		
		
		//------------------------------------------
		// horizontalAlign 
		//------------------------------------------
		
		private var _horizontalAlign:String = HorizontalAlign.JUSTIFY;
		
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			if (_horizontalAlign == value) return;
			_horizontalAlign = value;
			invalidateDisplayList();
		}
		
		
		//------------------------------------------
		// verticalAlign 
		//------------------------------------------
		
		private var _verticalAlign:String = VerticalAlign.TOP;
		
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			if (_verticalAlign == value) return;
			_verticalAlign = value;
			invalidateDisplayList();
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
			invalidateDisplayList();
		}

		
		//---------------------------------------------------------------------------------------------------------------------
		//
		//  Override Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (virtualLayout)
				virtualLayout.virtualLayoutView = this;
			
			if (selecter)
				selecter.virtualLayoutView = this;
		}
		
		override protected function measure():void
		{
			measuredWidth = measuredHeight = 110;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			// 设置滚动视图属性
			_horizontalScrollPosition = minHorizontalScrollPosition = width;
			_verticalScrollPosition = minVerticalScrollPosition = height;
			
			if (virtualLayout)
			{
				
				if (dataProvider)
				{
					// 数据源 或者 细胞类 发生变化 需要清理布局
					if (itemRendererClassChange)
					{
						virtualLayout.clearVirtualLayout();
						itemRendererClassChange = false;
					}
					
					virtualLayout.initVirtualLayout();
					virtualLayout.updateVirtualLayout();
				}
				else
				{
					// 数据源被清空  清理虚拟布局
					virtualLayout.clearVirtualLayout();
					selectedIndex = -1;
					selectedIndices.splice(0, selectedIndices.length);
				}
			}
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		//  失效方法用于单独刷新布局  单独调用布局的updateDisplayList方法，  而省去initLayout过去， 提高性能
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		private var invalidateCellLayoutFlag:Boolean = false;
		
		/**
		 * 布局失效
		 */		
		public function invalidateCellLayout():void
		{
			// 如果细胞布局为null  失效也没用 直接返回
			if (!virtualLayout) return;
			
			if (!invalidateCellLayoutFlag)
			{
				invalidateCellLayoutFlag = true;
				callLater(validateCellLayout).descript = "validateCellLayout()";
			}
		}
		
		private function validateCellLayout():void
		{
			if (invalidateCellLayoutFlag)
			{
				invalidateCellLayoutFlag = false;
				updateCellLayout();
			}
		}
		
		protected function updateCellLayout():void
		{
			virtualLayout.updateVirtualLayout();
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		//  细胞选中器失效
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		private var invalidateCellSelecterFlag:Boolean = false;
		
		private function invalidateCellSelecter():void
		{
			// 如果细胞选中器为null  失效也没用 直接返回
			if (!selecter) return;
			
			if (!invalidateCellSelecterFlag)
			{
				invalidateCellSelecterFlag = true;
				callLater(validateCellSelecter).descript = "validateCellSelecter()";
			}
		}
		
		private function validateCellSelecter():void
		{
			if (invalidateCellSelecterFlag)
			{
				invalidateCellSelecterFlag = false;
				updateCellSelecter();
			}
		}
		
		private function updateCellSelecter():void
		{
			// 更新细胞选中器
			// 首先更新已设置的细胞索引
			
			if (allowMultipleSelection)
			{
				// 允许多选的话  合并 selectedIndices selectedIndex
				if (selectedIndex >= 0 && selectedIndices.indexOf(selectedIndex) == -1)
					selectedIndices.push(selectedIndex);
			}
			else
			{
				// 不允许多选 
				// 首先清空 selectedIndices
				// 如果selectedIndex 被设置且有效的话 将selectedIndex 添加到selectedIndices
				selectedIndices.splice(0, selectedIndices.length);
				if (selectedIndex >= 0)
					selectedIndices.push(selectedIndex);
			}
			
			selecter.updateSelect();
		}
		
		
		public function itemRendererAdded(itemRenderer:IItemRenderer):void
		{
			var itemRendererEvent:ItemRendererEvent = new ItemRendererEvent(ItemRendererEvent.ADDED);
			itemRendererEvent.itemRenderer = itemRenderer;
			dispatchEvent(itemRendererEvent);
		}
		
		public function itemRendererRemoved(itemRenderer:IItemRenderer):void
		{
			var itemRendererEvent:ItemRendererEvent = new ItemRendererEvent(ItemRendererEvent.REMOVED);
			itemRendererEvent.itemRenderer = itemRenderer;
			dispatchEvent(itemRendererEvent);
		}
		
		public function itemRendererSelected(itemRenderer:IItemRenderer):void
		{
			// 渲染器被选中 派发change事件
			dispatchEvent(new UIEvent(UIEvent.CHANGE));
		}
		
	}
}