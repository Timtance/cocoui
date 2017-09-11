package coco.event
{
	import flash.events.Event;
	
	/**
	 *
	 * 动画事件
	 *  
	 * @author coco
	 * 
	 */	
	public class AnimationEvent extends Event
	{
		public function AnimationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * 动画完毕时候调用 
		 */		
		public static const COMPLETE:String = "animation_complete";
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//  Overridden methods: Event
		//
		//----------------------------------------------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function clone():Event
		{
			return new AnimationEvent(type, bubbles, cancelable);
		}
		
		
	}
}