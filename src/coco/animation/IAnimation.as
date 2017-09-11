package coco.animation
{
	/**
	 * TimeLine Interface
	 * 
	 * @author Coco
	 */	
	public interface IAnimation
	{
		
		/**
		 * 动画对象
		 *  
		 * @return 
		 * 
		 */		
		function get target():Object;
		function set target(value:Object):void;
		
		/**
		 * 动画时间
		 * 
		 * @return 
		 */		
		function get duration():Number;
		function set duration(value:Number):void;
		
		/**
		 * 动画当前时间
		 * 
		 * @return 
		 */		
		function get currentDuration():Number;
		function set currentDuration(value:Number):void;
		
		/**
		 * 动画缓动函数
		 *  
		 * @return 
		 */		
		function get ease():IEase;
		function set ease(value:IEase):void;
		
		/**
		 * 开始动画
		 */		
		function start():void;
		
		/**
		 * 停止动画
		 */		
		function stop():void;
		
		/**
		 * 清理动画
		 */		
		function clear():void;
		
		/**
		 * 添加一个动画属性
		 *  
		 * @param property 属性名称
		 * @param endValue 结束值
		 * @param beginValue  开始值
		 * 
		 */		
		function add(property:String, endValue:Number, beginValue:Number = NaN):void;
		
		/**
		 * 删除一个动画属性
		 *  
		 * @param property 属性名称
		 */		
		function remove(property:String):void;
		
	}
}