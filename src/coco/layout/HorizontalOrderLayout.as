package coco.layout
{
    import coco.core.UIComponent;
    
    /**
     * 
	 * 以水平方向进行排练  高与宽的时候自动换行 
	 * 
     * @author Coco
     * 
     */    
    public class HorizontalOrderLayout extends BasicLayout
    {
        public function HorizontalOrderLayout()
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
                var maxHeight:Number = 0;
                
                // set x y
                for (var i:int = 0; i < layoutView.numChildren; i++)
                {
                    ui = layoutView.getChildAt(i) as UIComponent;
                    if (ui && ui.includeInLayout)
                    {
                        if ((sx + ui.width + paddingRight) >= layoutView.width)
                        {
                            sx = paddingLeft;
                            sy += maxHeight + gap;
                            maxHeight = 0;
                        }
                        
                        ui.x = sx;
                        ui.y = sy;
                        maxHeight = Math.max(maxHeight, ui.height);
                        sx += ui.width + gap;
                    }
                }
            }
        }
        
    }
}