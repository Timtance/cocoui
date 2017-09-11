package coco.component
{
    import flash.events.MouseEvent;
    
    import coco.event.UIEvent;
    import coco.manager.IToolTip;
    import coco.util.CocoUI;
    
    
    /**
     * 按钮组件
     * 
     * @author Coco
     */	
    public class Button extends SkinComponent implements IToolTip
    {
        
        public function Button() 
        {
            super();
            
            mouseChildren = false;
			
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        }
		
		
        //---------------------------------------------------------------------------------------------------------------------
        //
        // Vars
        //
        //---------------------------------------------------------------------------------------------------------------------
		
        protected var labelDisplay:Label;
        
        //--------------------------------
        // 文本内容
        //--------------------------------
        private var _label:String;
        
        /**
         * 文本内容
         * @return 
         */		
        public function get label():String
        {
            return _label;
        }
        
        public function set label(value:String):void
        {
            if (_label == value)
                return;
            
            _label = value;
            
            invalidateProperties();
        }
        
        //--------------------------------
        // 字体大小
        //--------------------------------
        private var _fontSize:int = CocoUI.fontSize;
        
        /**
         * 字体大小
         * @return 
         */		
        public function get fontSize():int
        {
            return _fontSize;
        }
        
        public function set fontSize(value:int):void
        {
            if (_fontSize == value)
                return;
            
            _fontSize = value;
            
            invalidateProperties();
        }
        
        
        //--------------------------------
        // 字体颜色
        //--------------------------------
        private var _color:uint = CocoUI.fontColor;
        
        /**
         * 字体颜色 
         * @return 
         */		
        public function get color():uint
        {
            return _color;
        }
        
        public function set color(value:uint):void
        {
            if (_color == value)
                return;
            
            _color = value;
            
            invalidateProperties();
        }
        
        //--------------------------------
        // 密码格式显示
        //--------------------------------
        private var _displayAsPassword:Boolean = false;
        
        /**
         * 密码格式显示
         * @return 
         */		
        public function get displayAsPassword():Boolean
        {
            return _displayAsPassword;
        }
        
        public function set displayAsPassword(value:Boolean):void
        {
            if (_displayAsPassword == value)
                return;
            
            _displayAsPassword = value;
            
            invalidateProperties();
        }
        
        //--------------------------------
        // 文本水平对齐方式
        //--------------------------------		
        private var _textAlign:String = CocoUI.fontAlign;
        
        /**
         * 文本对齐方式
         * @return 
         */		
        public function get textAlign():String
        {
            return _textAlign;
        }
        
        public function set textAlign(value:String):void
        {
            if (_textAlign == value)
                return;
            
            _textAlign = value;
            
            invalidateProperties();
        }
		
		
		//--------------------------------
		// leftMargin
		//--------------------------------	
		
		private var _leftMargin:Number = CocoUI.fontLeftMargin;
		
		/**
		 * 段落的左边距，以像素为单位。
		 * 默认值为 null，它表示左边距为 0 像素。 
		 */
		public function get leftMargin():Number
		{
			return _leftMargin;
		}
		
		/**
		 * @private
		 */
		public function set leftMargin(value:Number):void
		{
			if (_leftMargin == value) return;
			_leftMargin = value;
			invalidateProperties();
		}
		
		
		//--------------------------------
		// rightMargin
		//--------------------------------	
		
		private var _rightMargin:Number = CocoUI.fontRightMargin;
		
		/**
		 * 段落的右边距，以像素为单位。
		 * 默认值为 null，它表示右边距为 0 像素。 
		 */
		public function get rightMargin():Number
		{
			return _rightMargin;
		}
		
		/**
		 * @private
		 */
		public function set rightMargin(value:Number):void
		{
			if (_rightMargin == value) return;
			_rightMargin = value;
			invalidateProperties();
		}
        
        //--------------------------------
        // 厚度字体
        //--------------------------------
        private var _bold:Boolean = CocoUI.fontBold;
        
        /**
         * 是否粗体
         * @return 
         */		
        public function get bold():Boolean
        {
            return _bold;
        }
        
        public function set bold(value:Boolean):void
        {
            if (_bold == value)
                return;
            
            _bold = value;
            
			invalidateProperties();
        }
        
        //--------------------------------
        // 字体
        //--------------------------------
        private var _fontFamily:String = CocoUI.fontFamily;
        
        /**
         * 字体默认 微软雅黑 
         * @return 
         */		
        public function get fontFamily():String
        {
            return _fontFamily;
        }
        
        public function set fontFamily(value:String):void
        {
            if (_fontFamily == value)
                return;
            
            _fontFamily = value;
            
			invalidateProperties();
        }
        
        //--------------------------------
        // 行距
        //--------------------------------
        private var _leading:Number = CocoUI.fontLeading;
        
        /**
         * 行与行之间的距离
         * 
         * @return 
         */		
        public function get leading():Number
        {
            return _leading;
        }
        
        public function set leading(value:Number):void
        {
            if (_leading == value)
                return;
            
            _leading = value;
            
			invalidateProperties();
        }
        
        
        //--------------------------------
        // html内容
        //--------------------------------
        private var _htmlText:String = null;
        
        /**
         * html文本
         * @return 
         */		
        public function get htmlText():String
        {
            return _htmlText;
        }
        
        public function set htmlText(value:String):void
        {
            if (_htmlText == value)
                return;
            
            _htmlText = value;
            
            invalidateProperties();
        }
		
		//--------------------------------
		// 鼠标按下
		//--------------------------------
		private var _isDown:Boolean;

		/**
		 * 是否鼠标按下 
		 * @return 
		 */		
		private function get isDown():Boolean
		{
			return _isDown;
		}

		private function set isDown(value:Boolean):void
		{
			if (_isDown == value) return;
			_isDown = value;
			invalidateSkin();
		}
		
		//---------------------
		//	toolTip
		//---------------------
		private var _tooltip:String;
		
		/**
		 * 工具提示 
		 */		
		public function get toolTip():String
		{
			return _tooltip;
		}
		
		public function set toolTip(value:String):void
		{
			_tooltip = value;
		}
		
		
        //---------------------------------------------------------------------------------------------------------------------
        //
        // Methods
        //
        //---------------------------------------------------------------------------------------------------------------------
        
        override protected function createChildren():void 
        {
            super.createChildren();
            
            labelDisplay = new Label();
            labelDisplay.addEventListener(UIEvent.RESIZE, label_resizeHandler);
            addChild(labelDisplay);
        }
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			labelDisplay.fontSize = fontSize;
			labelDisplay.color = color;
			labelDisplay.textAlign = textAlign;
			labelDisplay.fontFamily = fontFamily;
			labelDisplay.bold = bold;
			labelDisplay.leading = leading;
			labelDisplay.leftMargin = leftMargin;
			labelDisplay.rightMargin = rightMargin;
			
			// set Text
			if (_htmlText != null)
				labelDisplay.htmlText = _htmlText;
			else
				labelDisplay.text = _label;
		}
		
        override protected function measure():void
        {
            var defaultWidth:Number = 100;
            var defaultHeight:Number = 30;
            
            // width or height isNaN
            if (labelDisplay)
            {
                defaultWidth = Math.max(defaultWidth, labelDisplay.width + 10);
                defaultHeight = Math.max(defaultHeight, labelDisplay.height + 10);
            }
            
            measuredWidth = defaultWidth;
            measuredHeight = defaultHeight;
        }
		
        override protected function updateDisplayList():void
        {
            super.updateDisplayList();
			
            labelDisplay.setmeasuredSizeWithoutDispatchResizeEvent(width, height);
        }
		
		override protected function drawSkin():void
		{
			super.drawSkin();
			
			if (isDown)
			{
				graphics.beginFill(CocoUI.themeBackgroundColorSelected, backgroundAlpha);
				graphics.drawRoundRectComplex(0, 0, width, height, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius);
				graphics.endFill();
			}
		}
		
		protected function label_resizeHandler(event:UIEvent):void
		{
			invalidateSize();
			invalidateDisplayList();
			invalidateSkin();
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			isDown = false;
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			isDown = true;
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			isDown = false;
		}
		
    }
}


