package coco.component
{
	import coco.layout.HorizontalLayout;

	public class HGroup extends Group
	{
		public function HGroup()
		{
			super();
			
			layout = new HorizontalLayout();
			HorizontalLayout(layout).paddingLeft = paddingLeft;
			HorizontalLayout(layout).paddingRight = paddingRight;
			HorizontalLayout(layout).paddingTop = paddingTop;
			HorizontalLayout(layout).paddingBottom = paddingBottom;
			HorizontalLayout(layout).gap = gap;
			HorizontalLayout(layout).verticalAlign = verticalAlign;
			HorizontalLayout(layout).horizontalAlign = horizontalAlign;
		}
		
		private var _paddingLeft:Number = 10;
		
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			_paddingLeft = value;
			
			if (layout && layout is HorizontalLayout)
				HorizontalLayout(layout).paddingLeft = paddingLeft;
		}
		
		private var _paddingTop:Number = 10;
		
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void
		{
			_paddingTop = value;
			
			if (layout && layout is HorizontalLayout)
				HorizontalLayout(layout).paddingTop = paddingTop;
		}
		
		private var _paddingRight:Number = 10;
		
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			_paddingRight = value;
			
			if (layout && layout is HorizontalLayout)
				HorizontalLayout(layout).paddingRight = paddingRight;
		}
		
		private var _paddingBottom:Number =  10;
		
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void
		{
			_paddingBottom = value;
			
			if (layout && layout is HorizontalLayout)
				HorizontalLayout(layout).paddingBottom = paddingBottom;
		}
		
		private var _horizontalAlign:String = HorizontalAlign.LEFT;
		
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			_horizontalAlign = value;
			
			if (layout && layout is HorizontalLayout)
				HorizontalLayout(layout).horizontalAlign = horizontalAlign;
		}
		
		private var _verticalAlign:String = "top";
		
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			_verticalAlign = value;
			
			if (layout && layout is HorizontalLayout)
				HorizontalLayout(layout).verticalAlign = verticalAlign;
		}
		
		private var _padding:Number;
		
		public function get padding():Number
		{
			return _padding;
		}
		
		public function set padding(value:Number):void
		{
			_padding = value;
			
			if (layout && layout is HorizontalLayout)
				HorizontalLayout(layout).padding = padding;
		}
		
		private var _gap:Number = 10;
		
		public function get gap():Number
		{
			return _gap;
		}
		
		public function set gap(value:Number):void
		{
			_gap = value;
			
			if (layout && layout is HorizontalLayout)
				HorizontalLayout(layout).gap = gap;
		}
		
	}
}