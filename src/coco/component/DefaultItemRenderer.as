package coco.component
{
	import coco.util.CocoUI;
	
	
	
	
	/**
	 * DefaultItemRenderer
	 *
	 * <p>默认的渲染器</p>
	 *
	 * @author Coco
	 */
	public class DefaultItemRenderer extends ItemRenderer
	{
		public function DefaultItemRenderer()
		{
			super();
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Vars
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		protected var labelDisplay:Label;
		
		override public function set data(value:Object):void
		{
			super.data = value;
			invalidateProperties();
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		//  Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			labelDisplay = new Label();
			addChild(labelDisplay);
		}
		
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
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			labelDisplay.width = width;
			labelDisplay.height = height;
		}
		
		override protected function drawSkin():void
		{
			graphics.clear();
			if (autoDrawSkin)
			{
				graphics.lineStyle(borderThickness, borderColor, borderAlpha, true);
				graphics.beginFill(selected ? CocoUI.themeBackgroundColorSelected : backgroundColor, backgroundAlpha);
				graphics.drawRoundRectComplex(0, 0, width, height, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius);
				graphics.endFill();
			}
		}
	}
}
