package coco.core
{
    import flash.display.DisplayObject;
    import flash.display.Stage;
    import flash.events.IEventDispatcher;
    
    
    /**
     *UIComponent组件接口
     * @author Coco
     * 
     */	
    public interface IUIComponent extends IEventDispatcher, IInvalidateComponent
    {
        
		/**
		 * 组件名称 
		 * @return 
		 * 
		 */		
		function get name():String;
		function set name(value:String):void;
		
		/**
		 * 舞台
		 */		
		function get stage():Stage;
		
        /**
         * x坐标位置
         * 
         * @return 
         * 
         */		
        function get x():Number;
        function set x(value:Number):void;
        
        /**
         * y坐标位置
         *  
         * @return 
         * 
         */		
        function get y():Number;
        function set y(value:Number):void;
        
        /**
         * width 组件宽度
         *  
         * @return 
         * 
         */		
        function get width():Number;
        function set width(value:Number):void;
        
        /**
         * 组件测量宽度，如果组件width没有被赋值，请在测量方法<code>measure()</code>方法中，计算组件的测量宽度
         * @return 
         * 
         */		
        function get measuredWidth():Number;
        function set measuredWidth(value:Number):void;
        
        /**
         * height 组件高度
         *  
         * @return 
         * 
         */		
        function get height():Number;
        function set height(value:Number):void;
        
        /**
         * 组件测量高度，如果组件height没有被赋值，请在测量方法<code>measure()</code>方法中，计算组件的测量高度
         *  
         * @return 
         * 
         */		
        function get measuredHeight():Number;
        function set measuredHeight(value:Number):void;
        
        /**
         * 组件的Application
         *  
         * @return 
         * 
         */		
        function get application():Application;
        function set application(value:Application):void;
        
        /**
         *组件是否可见
         *  
         * @return 
         * 
         */		
        function get visible():Boolean;
        function set visible(value:Boolean):void;
        
        /**
         *isPopUp</br>
         *是否是弹出状态
         *@return 
         * 
         */		
        function get isPopUp():Boolean;
        function set isPopUp(value:Boolean):void;
		
		/**
		 *mouseChildren</br>
		 *显示列表子项是否可以鼠标交互
		 *@return 
		 * 
		 */		
		function get mouseChildren():Boolean;
		function set mouseChildren(value:Boolean):void; 
		
		/**
		 *mouseEnabled</br>
		 *是否可以鼠标交互
		 *@return 
		 * 
		 */		
		function get mouseEnabled():Boolean;
		function set mouseEnabled(value:Boolean):void; 
		
        /**
         *组件初始化方法
         */        
        function initialize():void;
		
		/**
		 * 子组件数
		 */		
		function get numChildren():int;
		
		/**
		 * 获取指定索引的组件
		 */		
		function getChildAt(index:int):DisplayObject;
		
		/**
		 * 添加子组件
		 */		
		function addChild(child:DisplayObject):DisplayObject;
		
		/**
		 * 添加组件到指定索引
		 */		
		function addChildAt(child:DisplayObject, index:int):DisplayObject;
		
		/**
		 * 删除组件
		 */	
		function removeChild(child:DisplayObject):DisplayObject
		
		/**
		 * 删除指定索引位置的组件
		 */	
		function removeChildAt(index:int):DisplayObject;
		
		/**
		 * 删除所有组件
		 */		
		function removeAllChild():void;
		
		/**
		 * 延时调用
		 */		
		function callLater(method:Function, ...args):CallLaterMethod;
		
		/**
		 * 设置用户尺寸大小 此方法与 width height 不一样
		 * 在设置大小的时候，不会派发resize事件
		 * @param w
		 * @param h
		 */		
		function setSizeWithoutDispatchResizeEvent(w:Number = NaN, h:Number = NaN):void;
		
		/**
		 * 设置测量尺寸大小 此方法与 measuredWidth measuredHeight 不一样
		 * 在设置大小的时候，不会派发resize事件
		 * @param w
		 * @param h
		 */	
		function setmeasuredSizeWithoutDispatchResizeEvent(w:Number = NaN, h:Number = NaN):void;
		
		/**
		 * 2016-05-30
		 * 是否包含在布局中
		 * @return 
		 */		
		function get includeInLayout():Boolean;
		function set includeInLayout(value:Boolean):void;
        
    }
}