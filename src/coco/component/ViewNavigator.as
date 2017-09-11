package coco.component
{
	import flash.display.DisplayObject;
	
	import coco.animation.Animation;
	import coco.animation.IEase;
	import coco.core.UIComponent;
	import coco.event.AnimationEvent;
	import coco.event.UIEvent;
	
	[Event(name="ui_change", type="coco.event.UIEvent")]
	
	/**
	 * 
	 * View Navigator
	 * 
	 * use <code>pushView(viewClass, directon)</code> call
	 * use <code>popView(directon)</code> call
	 * 
	 * [viewClass1, viewClass2, viewClass3, viewClass4, viewClass5]
	 * 
	 * @author Coco
	 * 
	 */    
	public class ViewNavigator extends UIComponent
	{
		public function ViewNavigator()
		{
			super();
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 视图切换的时候是否使用动画效果 
		 */		
		public var animationEnabled:Boolean = false;
		/**
		 * 视图切换的动画时间 
		 */		
		public var animationDuration:Number = 300;
		/**
		 * 视图切换的动画效果 
		 */		
		public var animationEase:IEase;
		
		/**
		 * 将要显示的视图
		 */		
		protected var animationView:DisplayObject;
		protected var animationning:Boolean = false;
		protected var animationDirection:String;
		
		private var viewClassStack:Vector.<Class> = new Vector.<Class>();
		
		//---------------------
		//	当前视图动画
		//---------------------
		
		private var _currentViewAnimation:Animation;
		
		public function get currentViewAnimation():Animation
		{
			if (!_currentViewAnimation)
			{
				_currentViewAnimation = new Animation();
				_currentViewAnimation.duration = animationDuration;
				if (animationEase)
					_currentViewAnimation.ease = animationEase;
			}
			
			return _currentViewAnimation;
		}
		
		//---------------------
		//	下一个视图动画
		//---------------------
		
		private var _newViewAnimation:Animation;
		
		public function get newViewAnimation():Animation
		{
			if (!_newViewAnimation)
			{
				_newViewAnimation = new Animation();
				_newViewAnimation.duration = animationDuration;
				if (animationEase)
					_newViewAnimation.ease = animationEase;
				_newViewAnimation.addEventListener(AnimationEvent.COMPLETE, newViewAnimation_completeHandler);
			}
			
			return _newViewAnimation;
		}
		
		protected var _currentView:DisplayObject;
		
		/**
		 *  当前视图实例
		 * @return 
		 */		
		public function get currentView():DisplayObject
		{
			return _currentView;
		}
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			// sync all child width height
			var child:DisplayObject;
			for (var i:int = 0; i < numChildren; i++)
			{
				child = getChildAt(i);
				child.width = width;
				child.height = height;
			}
		}
		
		/**
		 * 将一个视图推到堆栈顶部
		 * 
		 * @param viewClass
		 * @param direction 动画方向
		 * @param unqie 是否是唯一视图， 如果是唯一视图， 则堆栈中只保留唯一的一个视图
		 * @return 
		 */		
		public function pushView(viewClass:Class, direction:String = Direction.RIGHT, unique:Boolean = false):DisplayObject
		{
			// [viewClass1, viewClass2, viewClass3]
			// pushView(viewClass4)
			// [viewClass1, viewClass2, viewClass4]
			
			var view:DisplayObject = getView(viewClass);
			
			// 如果存在视图动画
			if (animationning)
			{
				// 如果动画类 就是 新的类 直接返回
				// 如果动画类 不是 新的类 结束当前动画
				if (animationView == view)  
					return animationView;
				else  
					endViewAnimation();
			}
			
			// 如果当前视图 已经是要推的视图 做任何操作
			if (currentView && currentView == view)
				return currentView;
			
			// 如果是唯一视图 删除缓存中的视图类
			if (unique)
			{
				var viewClassIndex:int = viewClassStack.indexOf(viewClass);
				if (viewClassIndex != -1)
					viewClassStack.splice(viewClassIndex, 1);
			}
			
			// 将视图类放入堆栈
			viewClassStack.push(viewClass);
			animationDirection = direction;
			
			initView(view);
			return view;
		}
		
		/**
		 * 从视图堆栈中推出一个视图， 返回到上个视图
		 */		
		public function popView(viewClass:Class = null, direction:String = Direction.LEFT):DisplayObject
		{
			// [viewClass1, viewClass2, viewClass3, viewClass4, viewClass5]
			// popView(viewClass3)
			// [viewClass1, viewClass2, viewClass3]
			if (viewClass && viewClassStack.lastIndexOf(viewClass) == -1)
				viewClass = null;
			
			if (viewClass == null && viewClassStack.length <= 1)
				return null;
			
			if (viewClass == null)
				viewClass = viewClassStack[viewClassStack.length - 2];
			
			viewClassStack = viewClassStack.slice(0, viewClassStack.lastIndexOf(viewClass) + 1);
			var view:DisplayObject = getView(viewClass);
			
			// 如果存在视图动画
			if (animationning)
			{
				// 如果动画类 就是 新的类 直接返回
				// 如果动画类 不是 新的类 结束当前动画
				if (animationView == view)  
					return animationView;
				else  
					endViewAnimation();
			}
			
			// 如果当前视图 已经是要推的视图 做任何操作
			if (currentView && currentView == view)
				return currentView;
			
			animationDirection = direction;
			
			initView(view);
			return view;
		}
		
		/**
		 * 获取视图实例
		 *  
		 * @param viewClass
		 * @return 
		 */		
		protected function getView(viewClass:Class):DisplayObject
		{
			var child:DisplayObject;
			for (var i:int = 0; i < numChildren; i++)
			{
				child = getChildAt(i);
				if(child is viewClass)
					return child;
			}
			
			// 如果还没有生成 实例个新的对象
			child = new viewClass() as DisplayObject;
			addChild(child);
			return child;
		}
		
		protected function initView(view:DisplayObject):void
		{
			view.width = width;
			view.height = height;
			view.visible = true;
			
			// 如果当前视图存在  且支持 动画 则开会视图动画
			// 否则 直接显示 新视图
			if (animationEnabled && currentView)
				beginViewAnimation(view);
			else
				endView(view);
		}
		
		/**
		 * 开始视图动画
		 * @param view
		 */		
		protected function beginViewAnimation(view:DisplayObject):void
		{
			// 指示动画开始
			animationning = true;
			animationView = view;
			
			currentViewAnimation.target = currentView;
			newViewAnimation.target = animationView;
			
			switch(animationDirection)
			{
				case Direction.LEFT: // 从左边出来
				{
					animationView.x = -width;
					animationView.y = 0;
					newViewAnimation.add("x", 0);
					currentViewAnimation.add("x", width);
					break;
				}
				case Direction.TOP: // 从上边出来
				{
					animationView.x = 0;
					animationView.y = -height;
					newViewAnimation.add("y", 0);
					currentViewAnimation.add("y", height);
					break;
				}
				case Direction.BOTTOM: // 从下边出来
				{
					animationView.x = 0;
					animationView.y = height;
					newViewAnimation.add("y", 0);
					currentViewAnimation.add("y", -height);
					break;
				}
				default :
				{
					// 从右边出来
					animationView.x = width;
					animationView.y = 0;
					newViewAnimation.add("x", 0);
					currentViewAnimation.add("x", -width);
					break;
				}
			}
			
			currentViewAnimation.start();
			newViewAnimation.start();
		}
		
		/**
		 * 结束视图动画
		 */		
		public function endViewAnimation():void
		{
			// 清空动画
			newViewAnimation.stop();
			newViewAnimation.clear();
			
			currentViewAnimation.stop();
			currentViewAnimation.clear();
			
			endView(animationView);
			
			animationning = false;
		}
		
		protected function endView(view:DisplayObject):void
		{
			// 隐藏当前视图
			if (currentView)
				currentView.visible = false;
			
			// 设置当前视图 当前视图类
			_currentView = view;
			currentView.x = currentView.y = 0;
			
			// dispatch chagne event
			dispatchEvent(new UIEvent(UIEvent.CHANGE));
		}
		
		protected function newViewAnimation_completeHandler(event:AnimationEvent):void
		{
			endViewAnimation();
		}
		
	}
}