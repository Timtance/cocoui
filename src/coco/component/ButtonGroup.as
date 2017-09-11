package coco.component
{
	
	
	/**
	 *
	 * button 按钮组
	 *  
	 * @author coco
	 * 
	 */	
	public class ButtonGroup extends List
	{
		public function ButtonGroup()
		{
			super();
			
			// 默认为一行
			itemRendererRowCount = 1;
			itemRendererClass = ButtonGroupButton;
			verticalAlign = VerticalAlign.JUSTIFY;
			verticalScrollEnabled = false;
			horizontalAlign = HorizontalAlign.JUSTIFY;
			horizontalScrollEnabled = false;
		}
		
		override protected function measure():void
		{
			measuredWidth = 100;
			measuredHeight = 30;
		}
		
	}
}