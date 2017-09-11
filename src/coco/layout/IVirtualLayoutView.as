package coco.layout
{
	import coco.component.IItemRenderer;
	import coco.component.IScrollView;
	import coco.helper.ISelectHelper;
	
	/**
	 *
	 * 虚拟布局视图接口
	 *  
	 * @author coco
	 * 
	 */	
	public interface IVirtualLayoutView extends IScrollView
	{
		
		/**
		 * 虚拟布局
		 */		
		function get virtualLayout():IVirtualLayout;
		function set virtualLayout(value:IVirtualLayout):void;
		
		/**
		 * 细胞视图辅助 用于对细胞元素的操作
		 */		
		function get selecter():ISelectHelper;
		function set selecter(value:ISelectHelper):void;
		
		/**
		 * 细胞宽度 如果被赋值 CellLayout.horizontalAlign = HorizontalAlign.JUSTIFY 将失效
		 */		
		function get itemRendererWidth():Number;
		function set itemRendererWidth(value:Number):void;
		
		/**
		 * 细胞高度 如果被赋值 CellLayout.verticalAlign = VerticalAlign.JUSTIFY 将失效
		 */		
		function get itemRendererHeight():Number;
		function set itemRendererHeight(value:Number):void;
		
		/**
		 * 细胞的列数
		 */
		function get itemRendererColumnCount():int;
		function set itemRendererColumnCount(value:int):void;
		
		/**
		 * 细胞的行数
		 */		
		function get itemRendererRowCount():int;
		function set itemRendererRowCount(value:int):void;
		
		/**
		 * 细胞类
		 */		
		function get itemRendererClass():Class;
		function set itemRendererClass(value:Class):void;
		
		/**
		 * 虚拟布局数据源
		 */		
		function get dataProvider():Array;
		function set dataProvider(value:Array):void;
		
		/**
		 * 显示的文本字段
		 */		
		function get labelField():String;
		function set labelField(value:String):void;
		
		/**
		 * 选中的索引
		 */		
		function get selectedIndex():int;
		function set selectedIndex(value:int):void;
		
		/**
		 * 选中的索引
		 */		
		function get selectedIndices():Vector.<int>;
		function set selectedIndices(value:Vector.<int>):void;
		
		/**
		 * 是否运行多选
		 */		
		function get allowMultipleSelection():Boolean;
		function set allowMultipleSelection(value:Boolean):void;
		
		/**
		 * 选中的对象
		 */	
		function get selectedItem():Object;
		
		/**
		 * 选中的对象组
		 */	
		function get selectedItems():Vector.<Object>;
		
		
		/**
		 * 水平对齐方式
		 */		
		function get horizontalAlign():String;
		function set horizontalAlign(value:String):void;
		
		/**
		 * 垂直对齐方式
		 */		
		function get verticalAlign():String;
		function set verticalAlign(value:String):void;
		
		/**
		 * 左边距
		 */		
		function get paddingLeft():Number;
		function set paddingLeft(value:Number):void;
		
		/**
		 * 右边距
		 */		
		function get paddingRight():Number;
		function set paddingRight(value:Number):void;
		
		/**
		 * 上边距
		 */		
		function get paddingTop():Number;
		function set paddingTop(value:Number):void;
		
		/**
		 * 下边距
		 */		
		function get paddingBottom():Number;
		function set paddingBottom(value:Number):void;
		
		/**
		 * 间隙值
		 */		
		function get gap():Number;
		function set gap(value:Number):void;
		
		/**
		 * 边距
		 */		
		function get padding():Number;
		function set padding(value:Number):void;
		
		/**
		 * 渲染器被添加
		 */		
		function itemRendererAdded(itemRenderer:IItemRenderer):void;
		
		/**
		 * 渲染器被移除
		 */		
		function itemRendererRemoved(itemRenderer:IItemRenderer):void;
		
		/**
		 * 渲染器被选中
		 */		
		function itemRendererSelected(itemRenderer:IItemRenderer):void;
	}
}