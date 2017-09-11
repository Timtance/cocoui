package coco.component
{
	import coco.event.ItemRendererEvent;
	
	[Event(name="itemRenderer_selected", type="coco.event.ItemRendererEvent")]
	
	public class ItemRenderer extends SkinComponent implements IItemRenderer
	{
		public function ItemRenderer()
		{
			super();
			
			mouseChildren = false;
			
			addEventListener(ItemRendererEvent.SELECTED, this_selectedHandler);
		}
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		//------------------------------------------
		// data 
		//------------------------------------------
		
		private var _data:Object;

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
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
			_labelField = value;
		}
		
		
		//------------------------------------------
		// index 
		//------------------------------------------
		
		private var _index:int;

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			if (_index == value) return;
			_index = value;
		}
		
		
		//------------------------------------------
		// selected 
		//------------------------------------------
		
		private var _selected:Boolean = false;

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if (_selected == value) return; 
			_selected = value;
			invalidateSkin();
		}
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		protected function this_selectedHandler(event:ItemRendererEvent):void
		{
			// 如果数据是空的 阻止正在选中事件
			if (!data)
				event.preventDefault();
		}
		

		
	}
}