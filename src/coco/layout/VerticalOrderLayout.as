package coco.layout
{
    import coco.core.UIComponent;
    
    /**
     * 1
     * 2
     * 3
     *  
     * @author Coco
     * 
     */    
    public class VerticalOrderLayout extends BasicLayout
    {
        public function VerticalOrderLayout()
        {
            super();
        }
        
        //---------------------------------------------------------------------------------------------------------------------
        //
        // Vars
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
			if (_padding == value) return;
			_padding = value;
			
			_paddingLeft = _paddingRight = _paddingTop = _paddingBottom = _padding;
			if (layoutView)
				layoutView.invalidateDisplayList();
		}
        
        //-------------------------------
        // paddingLeft
        //-------------------------------
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
        
        //-------------------------------
        // paddingTop
        //-------------------------------
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
        
        //-------------------------------
        // paddingRight
        //-------------------------------
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
        
        //-------------------------------
        // paddingBottom
        //-------------------------------
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
        
        //-------------------------------
        // gap
        //-------------------------------
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
                var sx:Number = paddingLeft;
                var sy:Number = paddingTop;
                var maxWidth:Number = 0;
                
                // set x y
                for (var i:int = 0; i < layoutView.numChildren; i++)
                {
                    ui = layoutView.getChildAt(i) as UIComponent;
                    if (ui && ui.includeInLayout)
                    {
                        if ((sy + ui.height + paddingBottom) >= layoutView.height)
                        {
                            sy = paddingTop;
                            sx += maxWidth + gap;
                            maxWidth = 0;
                        }
                        
                        ui.x = sx;
                        ui.y = sy;
                        maxWidth = Math.max(maxWidth, ui.width);
                        sy += ui.height + gap;
                    }
                }
            }
        }
        
    }
}