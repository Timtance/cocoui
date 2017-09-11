package coco.layout
{
    import coco.component.HorizontalAlign;
    import coco.component.VerticalAlign;
    import coco.core.UIComponent;
    
    /**
     * 水平布局
	 * 
     * @author Coco
     */	
    public class HorizontalLayout extends BasicLayout
    {
        public function HorizontalLayout()
        {
            super();
        }
        
        //---------------------------------------------------------------------------------------------------------------------
        //
        // Properties
        //
        //---------------------------------------------------------------------------------------------------------------------
		
		
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
			_padding = value;
			
			_paddingLeft = _paddingRight = _paddingTop = _paddingBottom = _padding;
			if (layoutView)
				layoutView.invalidateDisplayList();
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
            _paddingLeft = value;
            
            if (layoutView)
				layoutView.invalidateDisplayList();
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
            _paddingTop = value;
            
            if (layoutView)
				layoutView.invalidateDisplayList();
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
            _paddingRight = value;
            
            if (layoutView)
				layoutView.invalidateDisplayList();
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
            _paddingBottom = value;
            
            if (layoutView)
                layoutView.invalidateDisplayList();
        }
		
		//------------------------------------------
		// horizontalAlign 
		//------------------------------------------
        
        private var _horizontalAlign:String = HorizontalAlign.LEFT;
        
        public function get horizontalAlign():String
        {
            return _horizontalAlign;
        }
        
        public function set horizontalAlign(value:String):void
        {
            _horizontalAlign = value;
            
            if (layoutView)
                layoutView.invalidateDisplayList();
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
            _verticalAlign = value;
            
            if (layoutView)
                layoutView.invalidateDisplayList();
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
            _gap = value;
            
            if (layoutView)
                layoutView.invalidateDisplayList();
        }
        
        //---------------------------------------------------------------------------------------------------------------------
        //
        // Methods
        //
        //---------------------------------------------------------------------------------------------------------------------
        
        override public function updateLayout():void
        {
            if (layoutView)
            {
                var ui:UIComponent;
                var startX:Number = 0;
                var totalWidth:Number = getTotalWidth();
                var maxHeight:Number = 0;
                
                // set startX
                if (horizontalAlign == HorizontalAlign.CENTER)
                    startX = (layoutView.width - totalWidth) / 2;
                else if (horizontalAlign == HorizontalAlign.RIGHT)
                    startX = layoutView.width - paddingRight - totalWidth;
                else
                    startX = paddingLeft;
                
                // set x y
                for (var i:int = 0; i < layoutView.numChildren; i++)
                {
                    ui = layoutView.getChildAt(i) as UIComponent;
                    if (ui && ui.includeInLayout)
                    {
                        if (verticalAlign == VerticalAlign.MIDDLE)
                            ui.y = (layoutView.height - ui.height) / 2;
                        else if (verticalAlign == VerticalAlign.BOTTOM)
                            ui.y = layoutView.height - ui.height - paddingBottom;
                        else
                            ui.y = paddingTop;
                        
                        ui.x = startX;
                        startX += ui.width + gap;
                        
                        maxHeight = Math.max(maxHeight, ui.height);
                    }
                }
            }
        }
        
        private function getTotalWidth():Number
        {
            var ui:UIComponent;
            var totalWidth:Number = 0;
            for (var i:int = 0; i < layoutView.numChildren; i++)
            {
                ui = layoutView.getChildAt(i) as UIComponent;
                if (ui && ui.includeInLayout)
                {
                    if (i == 0)
                        totalWidth += ui.width;
                    else
                        totalWidth += ui.width + gap;
                }
            }
            
            return totalWidth;
        }
    }
}