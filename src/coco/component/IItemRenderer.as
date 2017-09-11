package coco.component
{
	import coco.core.IUIComponent;

	/**
	 *
	 * 细胞对象接口
	 *  
	 * @author coco
	 * 
	 */	
	public interface IItemRenderer extends IUIComponent
	{
		
		/**
		 * 细胞数据
		 */		
		function get data():Object;
		function set data(value:Object):void;
		
		/**
		 * 细胞索引
		 */		
		function get index():int;
		function set index(value:int):void;
		
		/**
		 * 细胞是否被选中
		 */		
		function get selected():Boolean;
		function set selected(value:Boolean):void;
		
		/**
		 * 显示的文本域
		 */		
		function get labelField():String;
		function set labelField(value:String):void;
		
	}
}