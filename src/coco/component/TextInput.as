package coco.component
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	
	import coco.event.UIEvent;
	
	[Event(name="ui_change", type="coco.event.UIEvent")]
	
	/**
	 * 文本输入组件
	 * 
	 * @author Coco
	 */	
	public class TextInput extends Label
	{
		public function TextInput()
		{
			super();
			
			backgroundColor = 0xFFFFFF; // textinput 默认背景不使用主题色 使用白色
			autoDrawSkin = true; // textinput 默认自动绘制皮肤
			mouseChildren = true;
			selectable = true;
			textAlign = TextFormatAlign.LEFT;
			
			addEventListener(MouseEvent.MOUSE_DOWN, this_mouseDownHandler);
		}
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		//--------------------------------
		// 是否可编辑
		//--------------------------------
		private var _editable:Boolean = true;
		
		/**
		 * TextField editable
		 * 
		 * @return 
		 */        
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
		
		//--------------------------------
		// 限制输入
		//--------------------------------
		private var _restrict:String = null;
		
		/**
		 * 限制输入
		 *  
		 * @return 
		 * 
		 */        
		public function get restrict():String
		{
			return _restrict;
		}
		
		public function set restrict(value:String):void
		{
			if (_restrict == value) return;
			_restrict = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			textDisplay.multiline = false; // textinput 不支持 enter 回车键
			textDisplay.addEventListener(Event.CHANGE, textField_changeHandler);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			textDisplay.type = editable ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
			textDisplay.restrict = restrict;
		}
		
		override protected function measure():void
		{
			super.measure();
			
			var defaultWidth:Number = 100;
			var defaultHeight:Number = 30;
			
			measuredWidth = Math.max(defaultWidth, measuredWidth + 10);
			measuredHeight = Math.max(defaultHeight, measuredHeight);
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			textDisplay.width = width  - 10;
			textDisplay.height = textDisplay.textHeight + 4;
			textDisplay.x = 5;
			textDisplay.y = (height - textDisplay.height) / 2;
		}
		
		protected function textField_changeHandler(event:Event):void
		{
			dispatchEvent(new UIEvent(UIEvent.CHANGE));
		}
		
		private function this_mouseDownHandler(event:MouseEvent):void
		{
			if (event.currentTarget == this && stage && textDisplay)
				stage.focus = textDisplay;
		}	
		
	}
}


