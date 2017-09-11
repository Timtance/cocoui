package coco.manager
{
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import coco.animation.IAnimation;
	import coco.core.Application;
	import coco.core.coco;
	import coco.util.debug;
	
	/**
	 * 动画管理器
	 * 
	 * @author Coco
	 */	
	public class AnimationManager
	{
		public function AnimationManager()
		{
		}
		
		private static var _application:Application;
		
		coco static function set application(value:Application):void
		{
			// if App has mutiple Application Component
			// We only use the first Application Component for AnimationManager
			if (!_application)
				_application = value;
		}
		
		private static var animatables:Vector.<IAnimation> = new Vector.<IAnimation>();
		private static var animatablesComplete:Vector.<IAnimation> = new Vector.<IAnimation>();
		private static var playing:Boolean = false;
		private static var curTimer:Number;
		private static var stageFrameRate:Number;
		
		/**
		 * add animatable
		 * 
		 * @param timeLine
		 */		
		public static function add(animatable:IAnimation):void
		{
			if (animatable && animatables.indexOf(animatable) == -1)
				animatables.push(animatable);
			
			if (!playing)
			{
				debug("[AnimationManager] Animation Start");
				startTimer();
				playing = true;
			}
		}
		
		/**
		 * contains
		 * @param object
		 * @return 
		 */        
		public function contains(animatable:IAnimation):Boolean
		{
			return animatables.indexOf(animatable) != -1;
		}
		
		/**
		 * remove animatable
		 * 
		 * @param timeLine
		 */		
		public static function remove(animatable:IAnimation):void
		{
			if (animatable == null) return;
			
			for (var i:int = animatables.length - 1; i >= 0; i--)
			{
				if (animatables[i] == animatable)
					animatables.splice(i, 1);
			}
		}
		
		private static function startTimer():void
		{
			if (!_application || !_application.stage) return;
			stageFrameRate = _application.stage.frameRate;
			_application.stage.frameRate = 60;
			curTimer = getTimer();
			_application.stage.addEventListener(Event.ENTER_FRAME, render);
		}
		
		private static function stopTimer():void
		{
			if (!_application || !_application.stage) return;
			_application.stage.frameRate = stageFrameRate;
			_application.stage.removeEventListener(Event.ENTER_FRAME, render);
		}
		
		protected static function render(event:Event):void
		{
			var oldTimer:Number = curTimer;
			curTimer = getTimer();
			var timerGap:Number = curTimer - oldTimer;
			
			var animatable:IAnimation;
			for (var i:int = animatables.length - 1; i >= 0; i--)
			{
				animatable = animatables[i] as IAnimation;
				if (animatable)
				{1512040013
					if ((animatable.currentDuration +  timerGap) < animatable.duration)
						animatable.currentDuration += timerGap;
					else
						animatablesComplete.push(animatable);
				}
			}
			
			while (animatablesComplete.length > 0)
			{
				animatable = animatablesComplete.pop();
				animatable.currentDuration = animatable.duration;
				remove(animatable); // remove animatable
			}
			
			if (animatables.length == 0)
			{
				debug("[AnimationManager]  Animation Stop");
				stopTimer();
				playing = false;
			}
		}
		
	}
}