package coco.component
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import coco.event.UIEvent;
	import coco.manager.PopUpManager;
	
	
	[Event(name="ui_change", type="coco.event.UIEvent")]
	
	
	/**
	 * DropDownList Component
	 * 
	 * @author Coco
	 * 
	 */	
	public class DropDownList extends TextInput
	{
		public function DropDownList()
		{
			super();
			textAlign = HorizontalAlign.CENTER;
			editable = false;
			selectable = false;
			addEventListener(MouseEvent.MOUSE_DOWN, this_mouseDownHandler);
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		private var isOpened:Boolean = false;
		
		private var list:List;
		
		//---------------------
		//	dataProvider
		//---------------------
		
		private var _dataProvider:Array;

		public function get dataProvider():Array
		{
			return _dataProvider;
		}

		public function set dataProvider(value:Array):void
		{
			_dataProvider = value;
			
			invalidateList();
		}
		
		
		//--------------------------------
		// request selection
		//--------------------------------
		
		private var _requestSelection:Boolean = true;
		
		public function get requestSelection():Boolean
		{
			return _requestSelection;
		}
		
		public function set requestSelection(value:Boolean):void
		{
			if (_requestSelection == value) return;
			_requestSelection = value;
			invalidateList();
		}
		
		
		//--------------------------------
		// 选中的索引
		//--------------------------------
		private var _selectedIndex:int = -1;
		
		/**
		 * 选中的索引 
		 */	
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			if (_selectedIndex == value)
				return;
			_selectedIndex = value;
			
			invalidateList();
		}
		
		//--------------------------------
		// 渲染器
		//--------------------------------
		
		private var _itemRendererClass:Class = DefaultItemRenderer;

		public function get itemRendererClass():Class
		{
			return _itemRendererClass;
		}

		public function set itemRendererClass(value:Class):void
		{
			if (_itemRendererClass == value) return;
			_itemRendererClass = value;
			invalidateList();
		}

		
		//--------------------------------
		// 选中的对象
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
		
		
		private var _labelField:String;

		public function get labelField():String
		{
			return _labelField;
		}

		public function set labelField(value:String):void
		{
			if (_labelField == value) return;
			_labelField = value;
			invalidateList();
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			list = new List();
			list.addEventListener(UIEvent.CHANGE, list_changeHandler);
			invalidateList();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			list.width = width;
		}
		
		protected function this_mouseDownHandler(event:MouseEvent):void
		{
			if (isOpened)
				close()
			else
				open();
		}
		
		protected function list_changeHandler(event:UIEvent):void
		{
			_selectedIndex = list.selectedIndex;
			dispatchEvent(event);
			close();
			
			if (dataProvider && selectedIndex != -1)
			{
				var data:Object = dataProvider[selectedIndex];
				if (data.hasOwnProperty(labelField))
					text = data[labelField];
				else
					text = data.toString();
			}
			else
				text = "";
		}
		
		public function open():void
		{
			application.stage.addEventListener(MouseEvent.MOUSE_DOWN, application_mouseDownHandler, true);
			
			list.x = 0;
			list.y = height;
			PopUpManager.addPopUp(list, this);
			
			isOpened = true;
		}
		
		public function close():void
		{
			application.stage.removeEventListener(MouseEvent.MOUSE_DOWN, application_mouseDownHandler, true);
			
			PopUpManager.removePopUp(list);
			
			isOpened = false;
		}
		
		protected function application_mouseDownHandler(event:MouseEvent):void
		{
			var item:DisplayObject = event.target as DisplayObject;
			if (!contains(item) && !list.contains(item))  // mouse down outside
				close();
		}
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// List Component Invalidate
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		private var invalidateListFlag:Boolean = false;
		
		private function invalidateList():void
		{
			if (!invalidateListFlag)
			{
				invalidateListFlag = true;
				callLater(validateList);
			}
		}
		
		private function validateList():void
		{
			if (invalidateListFlag)
			{
				invalidateListFlag = false;
				updateList();
			}
		}
		
		private function updateList():void
		{
			list.dataProvider = dataProvider;
			list.selectedIndex = selectedIndex;
			list.itemRendererClass = itemRendererClass;
			list.labelField = labelField;
			list.horizontalAlign = HorizontalAlign.JUSTIFY;
			list.verticalAlign = VerticalAlign.TOP;
		}
		
	}
}