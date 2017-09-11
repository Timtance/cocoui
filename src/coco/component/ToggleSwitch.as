package coco.component
{
	
	
	/**
	 *
	 * 切换按钮
	 *  
	 * @author coco
	 * 
	 */	
	public class ToggleSwitch extends ToggleButton
	{
		public function ToggleSwitch()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
		}
		
		override protected function measure():void
		{
			measuredWidth = 100;
			measuredHeight = 30;
		}
		
	}
}