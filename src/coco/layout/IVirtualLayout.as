package coco.layout
{
	
	/**
	 *
	 * 虚拟布局接口
	 * @author coco
	 */	
	public interface IVirtualLayout
	{
		
		/**
		 * 细胞视图
		 */		
		function get virtualLayoutView():IVirtualLayoutView;
		function set virtualLayoutView(value:IVirtualLayoutView):void;
		
		/**
		 * 初始化布局
		 */		
		function initVirtualLayout():void;
		
		/**
		 * 更新细胞布局
		 */		
		function updateVirtualLayout():void;
		
		/**
		 * 清理布局 
		 */		
		function clearVirtualLayout():void;
		
	}
}