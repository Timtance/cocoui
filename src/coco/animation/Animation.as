package coco.animation
{
    import flash.events.EventDispatcher;
    
    import coco.event.AnimationEvent;
    import coco.manager.AnimationManager;
	
	
	/**
	 * 动画完毕事件 
	 * @author coco
	 */	
	[Event(name="animation_complete", type="coco.event.AnimationEvent")]
	
	/**
	 * Animation
	 * 
	 * @author Coco
	 */	
	public class Animation extends EventDispatcher implements IAnimation
	{
		
		public function Animation(target:Object = null, duration:Number = 300, ease:IEase = null)
		{
			super();
			
			this.target = target;
			this.duration = duration;
			this.ease = ease;
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		private var animationProperties:Vector.<AnimationProperty> = new Vector.<AnimationProperty>();
		
		//------------------------------------------
		// target 
		//------------------------------------------
		
		private var _target:Object;

		public function get target():Object
		{
			return _target;
		}

		public function set target(value:Object):void
		{
			_target = value;
		}
		
		//------------------------------------------
		// duration 
		//------------------------------------------
		
		private var _duration:Number = 500;

		public function get duration():Number
		{
			return _duration;
		}

		public function set duration(value:Number):void
		{
			_duration = value;
		}
		
		
		//------------------------------------------
		// ease 
		//------------------------------------------

		private var _ease:IEase;

		public function get ease():IEase
		{
			return _ease;
		}

		public function set ease(value:IEase):void
		{
			_ease = value;
		}
		
		
		//------------------------------------------
		// currentDuration 
		//------------------------------------------
		
		private var _currentDuration:Number = 0;
		
		/**
		 * currentDuration
		 * ms
		 * 
		 * @return 
		 */	
		public function get currentDuration():Number
		{
			return _currentDuration;
		}
		
		public function set currentDuration(value:Number):void
		{
			if (_currentDuration == value)
				return;
			
			_currentDuration = value;
			
			doAnimation();
			
			if (currentDuration == duration)
			{
				// 动画结束
				var animationEvent:AnimationEvent = new AnimationEvent(AnimationEvent.COMPLETE);
				dispatchEvent(animationEvent);
			}
		}

		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 开始动画
		 */		
		public function start():void
		{
			AnimationManager.add(this);
		}
		
		/**
		 * 结束动画
		 */		
		public function stop():void
		{
			AnimationManager.remove(this);
		}
		
		/**
		 * 清理动画
		 */		
		public function clear():void
		{
			_currentDuration = 0;
			removeAll();
		}
		
		/**
		 * 添加一个动画属性
		 * 
		 * @param property
		 * @param endValue
		 * @param beginValue
		 * 
		 */		
		public function add(property:String, endValue:Number, beginValue:Number = NaN):void
		{
			var animationLen:int = animationProperties.length;
			for each(var ap:AnimationProperty in animationProperties)
			{
				if (ap.name == property)
				{
					ap.from = beginValue;
					ap.to = endValue;
					return;
				}
			}
			
			animationProperties.push(new AnimationProperty(property, beginValue, endValue));
		}
		
		/**
		 * 删除一个动画属性
		 * 
		 * @param property
		 */		
		public function remove(property:String):void
		{
			var animationLen:int = animationProperties.length;
			var ap:AnimationProperty;
			for (var i:int = animationLen - 1; i >= 0; i--)
			{
				ap = animationProperties[i];
				if (ap.name == property)
				{
					animationProperties.splice(i, 1);
					return;
				}
			}
		}
		
		public function removeAll():void
		{
			// 清空动画数组
			animationProperties.splice(0, animationProperties.length);
		}
		
		private function doAnimation():void
		{
			if (!target || animationProperties.length == 0) return;
			
			for each (var animationProperty:AnimationProperty in animationProperties)
			{
                if (isNaN(animationProperty.from))
                    animationProperty.from = target[animationProperty.name] as Number;
                
				target[animationProperty.name] = (animationProperty.to - animationProperty.from) * 
					(ease ? ease.getRatio(currentDuration / duration) : currentDuration / duration) +
					animationProperty.from;
			}
		}
		
		
	}
}

class AnimationProperty
{
	public function AnimationProperty(proName:String, proFrom:Number, proTo:Number)
	{
		name = proName;
		from = proFrom;
		to = proTo;
	}
	
	public var from:Number;
	public var to:Number;
	public var name:String;
}