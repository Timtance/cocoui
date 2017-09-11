package coco.component
{
	import coco.core.IUIComponent;
	import coco.helper.IScrollHelper;

	public interface IScrollView extends IUIComponent
	{
		
		/**
		 * 滚动辅助  没有scrollHelper 将无法进行滚动操作
		 * 滚动相关的逻辑代码应该在 ScrollHelper中
		 */		
		function get scrollHelper():IScrollHelper;
		function set scrollHelper(value:IScrollHelper):void;
		
		/**
		 * 滚动条  
		 */		
		function get scrollBar():IScrollBar;
		function set scrollBar(value:IScrollBar):void;
		
		/**
		 * 最小横向滚动位置
		 */		
		function get minHorizontalScrollPosition():Number;
		function set minHorizontalScrollPosition(value:Number):void;
		
		/**
		 * 最大横向滚动位置
		 */	
		function get maxHorizontalScrollPosition():Number;
		function set maxHorizontalScrollPosition(value:Number):void;
		
		/**
		 * 当前横向滚动位置
		 */	
		function get horizontalScrollPosition():Number;
		function set horizontalScrollPosition(value:Number):void;
		
		/**
		 * 最小纵向滚动位置
		 */		
		function get minVerticalScrollPosition():Number;
		function set minVerticalScrollPosition(value:Number):void;
		
		/**
		 * 最大纵向滚动位置
		 */		
		function get maxVerticalScrollPosition():Number;
		function set maxVerticalScrollPosition(value:Number):void;
		
		/**
		 * 当前纵向滚动位置
		 */		
		function get verticalScrollPosition():Number;
		function set verticalScrollPosition(value:Number):void;
		
		
		/**
		 * 是否以页数形式滚动
		 */		
		function get pageScrollEnabled():Boolean;
		function set pageScrollEnabled(value:Boolean):void;
		
		/**
		 * 是否可以水平滚动
		 */		
		function get horizontalScrollEnabled():Boolean;
		function set horizontalScrollEnabled(value:Boolean):void;
		
		/**
		 * 是否可以垂直滚动
		 */		
		function get verticalScrollEnabled():Boolean;
		function set verticalScrollEnabled(value:Boolean):void;
		
	}
}