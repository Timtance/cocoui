package coco.component
{
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import coco.core.UIComponent;
	import coco.event.UIEvent;
	
	
	/**
	 * 
	 * Dispatched When value was changed
	 * 
	 * @author Coco
	 * 
	 */	
	[Event(name="ui_change", type="coco.event.UIEvent")]
	
	/**
	 * 
	 * <pre><b>NumericStepper</b>
	 * default width 120
	 * default height 40</pre>
	 * 
	 * @author Coco
	 * 
	 */	
	public class NumericStepper extends UIComponent
	{
		public function NumericStepper()
		{
			super();
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//  Properties
		//
		//----------------------------------------------------------------------------------------------------------------
		
		//---------------------------------
		// maximum
		//--------------------------------- 
		
		private var maxChanged:Boolean = false;
		private var _maximum:Number = 100;
		
		public function get maximum():Number
		{
			return _maximum;
		}
		
		public function set maximum(value:Number):void
		{
			if (_maximum == value) return;
			_maximum = value;
			maxChanged = true;
			invalidateProperties();
		}
		
		
		//---------------------------------
		// minimum
		//--------------------------------- 
		
		private var _minimum:Number = 0;
		
		public function get minimum():Number
		{
			return _minimum;
		}
		
		public function set minimum(value:Number):void
		{
			if (_minimum == value) return;
			_minimum = value;
			invalidateProperties();
		}
		
		
		//---------------------------------
		// stepSize
		//--------------------------------- 
		
		private var _stepSize:Number = 1;
		
		public function get stepSize():Number
		{
			return _stepSize;
		}
		
		public function set stepSize(value:Number):void
		{
			if (_stepSize == value) return;
			_stepSize = value;
		}
		
		
		//---------------------------------
		// value
		//--------------------------------- 
		
		private var _value:Number = 0;
		
		public function get value():Number
		{
			if (isNaN(_value))
				return minimum;
			
			if (_value < minimum)
				return minimum;
			else if (_value > maximum)
				return maximum;
			else
				return _value;
		}
		
		public function set value(newValue:Number):void
		{
			if (_value == newValue) return;
			_value = newValue;
			invalidateProperties();
		}
		
		//---------------------------------
		// editable
		//--------------------------------- 
		
		private var _editable:Boolean = true;
		
		public function get editable():Boolean
		{
			return _editable;
		}
		
		public function set editable(value:Boolean):void
		{
			if (_editable == value) return;
			_editable = value;
			invalidateProperties();
		}
		
		
		protected var decrementButton:Button;
		protected var textinput:TextInput;
		protected var incrementButton:Button;
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//  Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			decrementButton = new Button();
			decrementButton.label = "-";
			decrementButton.addEventListener(MouseEvent.CLICK, decrementButton_clickHandler);
			addChild(decrementButton);
			
			textinput = new TextInput();
			textinput.textAlign = "center";
			textinput.restrict = "0-9.";
			textinput.addEventListener(FocusEvent.FOCUS_OUT, this_focusOutHandler);
			textinput.addEventListener(UIEvent.RESIZE, textinput_resizeHandler);
			addChild(textinput);
			
			incrementButton = new Button();
			incrementButton.label = "+";
			incrementButton.addEventListener(MouseEvent.CLICK, incrementButton_clickHandler);
			addChild(incrementButton);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (minimum > maximum)
			{
				if (maxChanged)
					_maximum = _minimum;
				else
					_minimum = _maximum;
			}
			
			textinput.editable = editable;
			textinput.text = value.toString();
		}
		
		override protected function measure():void
		{
			super.measure();
			
			measuredHeight = 40;
			measuredWidth = 3 * measuredHeight;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			decrementButton.width = decrementButton.height =
				incrementButton.width = incrementButton.height = height;
			textinput.x = height;
			textinput.width = width - height * 2;
			textinput.height = height;
			incrementButton.x = width - height;
		}
		
		protected function textinput_resizeHandler(event:UIEvent):void
		{
			invalidateSize();
			invalidateDisplayList();
		}
		
		protected function incrementButton_clickHandler(event:MouseEvent):void
		{
			value = getNextValue(true);
			dispatchEvent(new UIEvent(UIEvent.CHANGE));
		}
		
		protected function decrementButton_clickHandler(event:MouseEvent):void
		{
			value = getNextValue(false);
			dispatchEvent(new UIEvent(UIEvent.CHANGE));
		}
		
		protected function this_focusOutHandler(event:FocusEvent):void
		{
			value = int(textinput.text);
			dispatchEvent(new UIEvent(UIEvent.CHANGE));
		}
		
		protected function getNextValue(increment:Boolean):Number
		{
			if(isNaN(value))
				return 0;
			
			if (stepSize == 0)
				return value;
			
			var newValue:Number;
			
			// 解决精度问题
			// 如果stepSize为小数，先进行缩放
			// 如stepSize为0.1 则先把value跟stepSize放大10倍再计算,计算完再缩小10倍
			var scale:Number = 1;
			if (stepSize != Math.round(stepSize))
			{
				const parts:Array = stepSize.toString().split("."); 
				scale = Math.pow(10, parts[1].length);
			}
			
			if (increment)
				newValue =  (scale * value + scale * stepSize) / scale;
			else
				newValue = (scale * value - scale * stepSize) / scale;
			
			return newValue;
		}
		
	}
}