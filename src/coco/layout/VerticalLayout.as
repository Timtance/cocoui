package coco.layout
{
	import coco.component.HorizontalAlign;
	import coco.component.VerticalAlign;
	import coco.core.UIComponent;
	
	/**
	 * 垂直布局
	 * 
	 * @author Coco
	 */	
	public class VerticalLayout extends BasicLayout
	{
		public function VerticalLayout()
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
        // horizontalAlign
        //-------------------------------
		private var _horizontalAlign:String = HorizontalAlign.LEFT;
		
        /**
         * left center right
         * 
         * @return 
         */        
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
		
        //-------------------------------
        // verticalAlign
        //-------------------------------
		private var _verticalAlign:String = VerticalAlign.TOP;
		
        /**
         * top middle bottom
         * @return 
         */        
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
				var startY:Number = 0;
                var totalHeight:Number = getTotalHeight();
                var maxWidth:Number = 0;
                
				// set startY
				if (verticalAlign == VerticalAlign.MIDDLE)
					startY = (layoutView.height - totalHeight) / 2;
				else if (verticalAlign == VerticalAlign.BOTTOM)
					startY = layoutView.height - paddingBottom - totalHeight;
				else
					startY = paddingTop;
				
				// set x y
				for (var i:int = 0; i < layoutView.numChildren; i++)
				{
					ui = layoutView.getChildAt(i) as UIComponent;
					if (ui && ui.includeInLayout)
					{
						if (horizontalAlign == HorizontalAlign.CENTER)
							ui.x = (layoutView.width - ui.width) / 2;
						else if (horizontalAlign == HorizontalAlign.RIGHT)
							ui.x = layoutView.width - ui.width - paddingRight;
						else
							ui.x = paddingLeft;
						
						ui.y = startY;
						startY += ui.height + gap;
                        
                        maxWidth = Math.max(maxWidth, ui.width);
					}
				}
			}
		}
		
		private function getTotalHeight():Number
		{
			var ui:UIComponent;
			var totalHeight:Number = 0;
			for (var i:int = 0; i < layoutView.numChildren; i++)
			{
				ui = layoutView.getChildAt(i) as UIComponent;
				if (ui && ui.includeInLayout)
				{
                    if (i == 0)
                        totalHeight += ui.height;
                    else
					    totalHeight += gap + ui.height;
				}
			}
			
			return totalHeight;
		}
		
	}
}