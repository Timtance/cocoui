package coco.util
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 *
	 * 图形绘制辅助
	 *  
	 * @author coco
	 * 
	 */	
	public class GraphicsDrawer
	{
		public function GraphicsDrawer()
		{
		}
		
		/**
		 *
		 * 画9宫格位图
		 *  
		 * @param graphics
		 * @param bitmapdata
		 * @param scale9Grid
		 * @param width
		 * @param height
		 * 
		 */		
		public static function drawScale9GridBitmapdata(graphics:Graphics,
														bitmapdata:BitmapData, 
														scale9Grid:Scale9Grid,
														width:Number, 
														height:Number):void
		{
			drawBitmapdata(graphics, getRectBitmapdata(bitmapdata, 
				new Rectangle(0,
					0, 
					scale9Grid.paddingLeft, 
					scale9Grid.paddingTop)), 
				scale9Grid.paddingLeft, 
				scale9Grid.paddingTop); // left top
			
			drawBitmapdata(graphics, getRectBitmapdata(bitmapdata, 
				new Rectangle(0, 
					scale9Grid.paddingTop, 
					scale9Grid.paddingLeft, 
					bitmapdata.height - scale9Grid.paddingTop - scale9Grid.paddingBottom)), 
				scale9Grid.paddingLeft, 
				height - scale9Grid.paddingTop - scale9Grid.paddingBottom, 
				0, 
				
				scale9Grid.paddingTop); // left middle
			drawBitmapdata(graphics, getRectBitmapdata(bitmapdata, 
				new Rectangle(0, 
					bitmapdata.height - scale9Grid.paddingBottom, 
					scale9Grid.paddingLeft, 
					scale9Grid.paddingBottom)), 
				scale9Grid.paddingLeft, 
				scale9Grid.paddingBottom, 
				0, 
				height - scale9Grid.paddingBottom); // left bottom
			
			drawBitmapdata(graphics, getRectBitmapdata(bitmapdata, 
				new Rectangle(scale9Grid.paddingLeft, 
					0, 
					bitmapdata.width - scale9Grid.paddingLeft - scale9Grid.paddingRight, 
					scale9Grid.paddingTop)), 
				width - scale9Grid.paddingLeft -scale9Grid.paddingRight, 
				scale9Grid.paddingTop, 
				scale9Grid.paddingLeft); // center top
			
			drawBitmapdata(graphics, getRectBitmapdata(bitmapdata, 
				new Rectangle(scale9Grid.paddingLeft, 
					scale9Grid.paddingTop, 
					bitmapdata.width - scale9Grid.paddingLeft - scale9Grid.paddingRight, 
					bitmapdata.height - scale9Grid.paddingTop - scale9Grid.paddingBottom)), 
				width - scale9Grid.paddingLeft - scale9Grid.paddingRight, 
				height - scale9Grid.paddingTop - scale9Grid.paddingBottom, 
				scale9Grid.paddingLeft, 
				scale9Grid.paddingTop); // center middle
			
			drawBitmapdata(graphics, getRectBitmapdata(bitmapdata, 
				new Rectangle(scale9Grid.paddingLeft, 
					bitmapdata.height- scale9Grid.paddingBottom, 
					bitmapdata.width - scale9Grid.paddingLeft - scale9Grid.paddingRight, 
					scale9Grid.paddingBottom)), 
				width - scale9Grid.paddingLeft - scale9Grid.paddingRight, 
				scale9Grid.paddingBottom, 
				scale9Grid.paddingLeft, 
				height - scale9Grid.paddingBottom); // center bottom
			
			drawBitmapdata(graphics, getRectBitmapdata(bitmapdata, 
				new Rectangle(bitmapdata.width - scale9Grid.paddingRight, 
					0, 
					scale9Grid.paddingRight, 
					scale9Grid.paddingTop)), 
				scale9Grid.paddingRight, 
				scale9Grid.paddingTop, 
				width - scale9Grid.paddingRight); // right top
			
			drawBitmapdata(graphics, getRectBitmapdata(bitmapdata, 
				new Rectangle(bitmapdata.width - scale9Grid.paddingRight, 
					scale9Grid.paddingTop, 
					scale9Grid.paddingRight, 
					bitmapdata.height - scale9Grid.paddingTop - scale9Grid.paddingBottom)), 
				scale9Grid.paddingRight, 
				height - scale9Grid.paddingTop - scale9Grid.paddingBottom, 
				width - scale9Grid.paddingRight, 
				scale9Grid.paddingTop); // right middle
			
			drawBitmapdata(graphics, getRectBitmapdata(bitmapdata, 
				new Rectangle(bitmapdata.width - scale9Grid.paddingRight, 
					bitmapdata.height - scale9Grid.paddingBottom, 
					scale9Grid.paddingRight, 
					scale9Grid.paddingBottom)), 
				scale9Grid.paddingRight, 
				scale9Grid.paddingBottom, 
				width - scale9Grid.paddingRight, 
				height - scale9Grid.paddingBottom); // right bottom
		}
		
		private static function getRectBitmapdata(source:BitmapData, rect:Rectangle):BitmapData
		{
			var data:BitmapData = new BitmapData(rect.width, rect.height);
			data.copyPixels(source, rect, new Point(0, 0));
			return data;
		}
		
		/**
		 * 画位图
		 *  
		 * @param graphics
		 * @param bitmapdata
		 * @param width
		 * @param height
		 * @param x
		 * @param y
		 * @param fillMode
		 * @param smooth
		 * 
		 */		
		public static function drawBitmapdata(graphics:Graphics,
											  bitmapdata:BitmapData, 
											  width:Number, 
											  height:Number,  
											  x:Number = 0, 
											  y:Number = 0,
											  radius:Number = 0,
											  fillMode:String = "scale",
											  smooth:Boolean = true):void
		{
			var fillWidth:Number = fillMode == "clip" ? Math.min(width, bitmapdata.width) : width;
			var fillHeight:Number = fillMode == "clip" ? Math.min(height, bitmapdata.height) : height;
			var matrix:Matrix = new Matrix();
			if (fillMode == "scale")
				matrix.scale(width/bitmapdata.width, height/bitmapdata.height);
			matrix.translate(x, y);
			graphics.beginBitmapFill(bitmapdata, matrix, fillMode == "repeat" ? true : false, smooth);
			graphics.drawRoundRect(x, y, fillWidth, fillHeight, radius);
			graphics.endFill();
		}
		
	}
}