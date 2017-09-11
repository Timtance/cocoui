package coco.component
{
	import coco.util.CocoUI;
	
	/**
	 * 
	 * @author Coco
	 * 
	 */	
	public class ButtonGroupButton extends Button implements IItemRenderer
	{
		public function ButtonGroupButton()
		{
			super();
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Vars
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		private var _data:Object;
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			if (_data == value) return;
			_data = value;
			invalidateProperties();
		}
		
		
		private var _index:int = -1;
		
		public function get index():int
		{
			return _index;
		}
		
		public function set index(value:int):void
		{
			_index = value;
		}
		
		
		private var _selected:Boolean= false;
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if (_selected == value) return;
			_selected = value;
			invalidateProperties();
			invalidateSkin();
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
			invalidateProperties();
		}
		
		private var _backgroundColorSelected:uint = CocoUI.themeBackgroundColorSelected;

		/**
		 *
		 * 选中的背景色
		 *  
		 * @return 
		 * 
		 */		
		public function get backgroundColorSelected():uint
		{
			return _backgroundColorSelected;
		}

		public function set backgroundColorSelected(value:uint):void
		{
			if (_backgroundColorSelected == value)
			_backgroundColorSelected = value;
			invalidateSkin();
		}
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (data)
			{
				if (data.hasOwnProperty(labelField))
					labelDisplay.text = data[labelField];
				else
					labelDisplay.text = data.toString();
			}
			else
				labelDisplay.text = "";
		}
		
		override protected function drawSkin():void
		{
			graphics.clear();
			
			if (autoDrawSkin)
			{
				graphics.lineStyle(borderThickness, borderColor, borderAlpha, true);
				graphics.beginFill(selected ? backgroundColorSelected : backgroundColor, backgroundAlpha);
				graphics.drawRoundRectComplex(0, 0, width, height, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius);
				graphics.endFill();
			}
		}
		
	}
}