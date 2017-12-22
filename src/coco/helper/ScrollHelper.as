package coco.helper
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import coco.animation.Animation;
	import coco.animation.EaseOut;
	import coco.animation.IEase;
	import coco.component.IScrollView;
	import coco.event.AnimationEvent;
	import coco.event.DragEvent;
	import coco.manager.AnimationManager;
	
	/**
	 * 
	 * 滚动辅助
	 * 
	 * @author Coco
	 * 
	 */ 
	public class ScrollHelper implements IScrollHelper
	{
		public function ScrollHelper()
		{
			
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		//  Variables
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		//------------------------------------------
		//	scrollView
		//------------------------------------------
		
		private var _scrollView:IScrollView;
		
		public function get scrollView():IScrollView
		{
			return _scrollView;
		}
		
		public function set scrollView(value:IScrollView):void
		{
			_scrollView = value;
		}
		
		/**
		 * 最小速率 当滚动的速度等与这个值的时候将会停止滚动
		 */		
		public var minVelocity:Number = 0.05;
		/**
		 * 减速率
		 * 
		 * 速度 ＊ 减速率 ^ 时间 ＝ 当前速度
		 * 速度 ＊ 减速率  ＝ 第1秒的速度
		 * 速度 ＊ 减速率 ＊ 减速率 ＝ 第2秒的速度
		 * 速度 ＊ 减速率 ＊ 减速率＊ 减速率 ＝ 第3秒的速度
		 * 
		 * 速度 (pixel/ms)  * 减速率 ^ 时间(ms)
		 *  
		 */		
		public var decelerationRate:Number = 0.996;  
		
		/**
		 * 滚动过程中的 效果 默认 EasePower
		 */		
		public var throwEase:IEase = new EaseOut();
		
		/**
		 * 按页滚动过程中的 动画
		 */		
		public var pageEase:IEase = new EaseOut();
		
		/**
		 * 按页滚动过程中的 动画持续时间(ms) 默认值500ms
		 */		
		public var pageDuration:Number = 500;
		
		/**
		 * 视图超出边界后 回弹的动画 
		 */		
		public var elasticityEase:IEase = new EaseOut();
		
		/**
		 * 视图超出边界后 回弹的动画时间
		 */	
		public var elasticityDuration:Number = 500;
		
		
		/**
		 * 回弹率  0-1 越小拖拽超出视图范围越大
		 */		
		public var elasticityRatio:Number = 0.7;
		
		/**
		 * 刷新比率 
		 */		
		public var dragRefreshRation:Number = 0.85;
		
		/**
		 * 是否需要派发拖拽更新事件 
		 */		
		private var needDispatchDragRefreshEvent:Boolean = false;
		
		/**
		 * 指示是否是拖拽操作 
		 */		
		private var isDrag:Boolean = false;
		/**
		 * 指示当前状态 是否是否滚动操作
		 */		
		private var mouseDownPoint:Point = new Point();
		/**
		 * 鼠标移动点数组
		 */		
		private var mousePoints:Vector.<MousePoint> = new Vector.<MousePoint>();
		/**
		 * 滚动状态保持的帧数
		 * 
		 */		
		private var moveKeepFrameCount:int = 0;
		private var moveMaxFrameCount:int = 0;
		
		/**
		 * 鼠标按下时候垂直方向的页数
		 */		
		private var mouseDownVerticalPage:int = 0;
		
		/**
		 * 垂直方向最大页数 
		 */		
		private var verticalMaxPage:int = 0;
		
		/**
		 * 鼠标按下时候水平方向的页数 
		 */		
		private var mouseDownHorizontalPage:int = 0;
		
		/**
		 * 水平方向最大页数 
		 */		
		private var horizontalMaxPage:int = 0;
		
		private var moveMinDistance:Number = 5; //pixel
		private var horizontalScrollPositionOld:Number;
		private var verticalScrollPositionOld:Number;
		private var horizontalScrollThrowTween:Animation;
		private var horizontalScrollFinishTween:Animation;
		private var verticalScrollThrowTween:Animation;
		private var verticalScrollFinishTween:Animation;
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		//  Methods
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		public function startWork():void
		{
			if (!scrollView) return;
			
			scrollView.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		public function stopWork():void
		{
			if (!scrollView) return;
			
			scrollView.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			// 停止当前的滚动
			finishScrollPosition();
			
			// 记录当前视图滚动位置
			horizontalScrollPositionOld = scrollView.horizontalScrollPosition;
			verticalScrollPositionOld = scrollView.verticalScrollPosition;
			
			// 记录当前的鼠标坐标
			mouseDownPoint.x = event.stageX;
			mouseDownPoint.y = event.stageY;
			
			// 清空鼠标移动点数组
			mousePoints.splice(0, mousePoints.length);
			
			// 鼠标按下 - move 如果保持时间 60ms 就说明滚动结束
			moveMaxFrameCount = Math.ceil(60 * scrollView.application.applicationFPS / 1000);
			
			// 记录鼠标按下时当前页数
			horizontalMaxPage = Math.ceil(scrollView.maxHorizontalScrollPosition / scrollView.minHorizontalScrollPosition);
			mouseDownHorizontalPage = Math.ceil(horizontalScrollPositionOld / scrollView.minHorizontalScrollPosition);
			verticalMaxPage = Math.ceil(scrollView.maxVerticalScrollPosition / scrollView.minVerticalScrollPosition);
			mouseDownVerticalPage = Math.ceil(verticalScrollPositionOld / scrollView.minVerticalScrollPosition);
			
			//			debug("[ScrollHelper] Horizontal: " + mouseDownHorizontalPage + "/" + horizontalMaxPage + 
			//				" Vertical: " + mouseDownVerticalPage + "/" + verticalMaxPage);
			
			// 鼠标按下 开始记录鼠标移动 鼠标弹起 事件
			if (scrollView && scrollView.stage)
			{
				scrollView.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
				scrollView.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
				scrollView.stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		protected function mouseMoveHandler(event:MouseEvent):void
		{
			// 鼠标移动事件
			// 1 只有移动的距离大于最小的移动距离的时候才开始移动， 为了防止将点击操作勿识别为移动操作
			// 2 确认是移动操作的时候 开始记录鼠标移动信息
			
			// 更新新的鼠标点
			var dx:Number = event.stageX - mouseDownPoint.x;
			var dy:Number = event.stageY - mouseDownPoint.y;
			
			// 不是按页滚动  水平滚动有效   可以执行拖拽操作 
			if (scrollView.horizontalScrollEnabled && Math.abs(dx) > moveMinDistance)
			{
				dragBegin();
				
				if (!scrollView.pageScrollEnabled)
					dragHorizontal(dx > 0 ? dx - moveMinDistance : dx + moveMinDistance);
			}
			
			// 不是按页滚动  垂直滚动有效   可以执行拖拽操作
			if (scrollView.verticalScrollEnabled && Math.abs(dy) > moveMinDistance)
			{
				dragBegin();
				
				if (!scrollView.pageScrollEnabled)
					dragVertical(dy > 0 ? dy - moveMinDistance : dy + moveMinDistance);
			}
			
			// 如果当前是move状态 
			if (isDrag)
			{
				moveKeepFrameCount = 0;
				
				// 添加鼠标移动点 最多保留5点
				mousePoints.push(new MousePoint(event.stageX, event.stageY, getTimer()));
				if (mousePoints.length > 5)
					mousePoints.shift();
			}
			
			// Note... just for smooth
			event.updateAfterEvent();
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			if (isDrag)
			{
				calculateThrowVelocity();
				dragEnd();
			}
			else
			{
				finishHorizontalScrollPosition();
				finishVerticalScrollPosition();
			}
			
			scrollView.mouseChildren = true;
			
			// 鼠标释放 取消滚动监听
			if (scrollView && scrollView.stage)
			{
				scrollView.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, true);
				scrollView.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
				scrollView.stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		protected function enterFrameHandler(event:Event):void
		{
			// enter
			moveKeepFrameCount++;
			
			if (moveKeepFrameCount >= moveMaxFrameCount)
			{
				mousePoints.splice(0, mousePoints.length);
				dragEnd();
			}
		}
		
		private function dragBegin():void
		{
			if (isDrag) return;
			
			isDrag = true;
			
			scrollView.mouseChildren = false;
			
			var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_BEGIN);
			scrollView.dispatchEvent(dragEvent);
		}
		
		private function dragEnd():void
		{
			if (!isDrag) return;
			
			isDrag = false;
			
			var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_END);
			scrollView.dispatchEvent(dragEvent);
		}
		
		private function calculateThrowVelocity():void
		{
			// 少于2点 无法计算出速度
			if (mousePoints.length < 2) return;
			
			var vx:Number;
			var vxtotal:Number = 0;
			var vy:Number;
			var vytotal:Number = 0;
			var vc:int = 0;
			var mouseOldPoint:MousePoint = mousePoints.shift();
			var mouseNewPoint:MousePoint;
			while (mousePoints.length > 0)
			{
				mouseNewPoint = mousePoints.shift();
				vx = (mouseNewPoint.x - mouseOldPoint.x) / (mouseNewPoint.time - mouseOldPoint.time);
				vy = (mouseNewPoint.y - mouseOldPoint.y) / (mouseNewPoint.time - mouseOldPoint.time);
				vxtotal += vx;
				vytotal += vy;
				vc++;
				mouseOldPoint = mouseNewPoint;
			}
			
			vx = vxtotal / vc;
			vy = vytotal / vc;
			
			// throw horizontal
			if (scrollView.horizontalScrollEnabled)
				throwHorizontal(vx);
			
			// throw vertical
			if (scrollView.verticalScrollEnabled)
				throwVertical(vy);
		}
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		//  Horizontal Drag Scroll 
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		private function dragHorizontal(horizontalDistance:Number):void
		{
			var scale:Number = scrollView.application ? scrollView.application.scaleX : 1; 
			horizontalDistance = horizontalDistance / scale; // application was scale
			dragHorizontalScrollPosition(horizontalScrollPositionOld - horizontalDistance);
		}
		
		private function throwHorizontal(horizontalVelocity:Number):void
		{
			var scale:Number = scrollView.application ? scrollView.application.scaleX : 1; // application was scale
			horizontalVelocity = horizontalVelocity / scale; 
			horizontalScrollPositionOld = scrollView.horizontalScrollPosition;
			
			if (Math.abs(horizontalVelocity) > minVelocity)
			{
				if (scrollView.pageScrollEnabled)
				{
					var newPage:int = horizontalVelocity > 0 ? (mouseDownHorizontalPage -1) : (mouseDownHorizontalPage + 1);
					if (newPage > horizontalMaxPage)
					{
						// 翻页结束
						scrollView.dispatchEvent(new DragEvent(DragEvent.PAGE_END));
					}
					else if (newPage < 1)
					{
						// 翻到首页超出范围
						scrollView.dispatchEvent(new DragEvent(DragEvent.PAGE_BEGIN));
					}
					else
					{
						throwHorizontalScrollPosition(newPage * scrollView.minHorizontalScrollPosition, pageDuration, pageEase);
					}
				}
				else
				{
					// 水平滚动
					throwHorizontalScrollPosition(horizontalScrollPositionOld + getThrowDistance(horizontalVelocity), 
						getThrowDuration(horizontalVelocity), throwEase);
				}
			}
			else
				finishHorizontalScrollPosition();
		}
		
		private function dragHorizontalScrollPosition(newHorizontalScrollPositon:Number):void
		{
			if (newHorizontalScrollPositon < scrollView.minHorizontalScrollPosition)
				newHorizontalScrollPositon -= (newHorizontalScrollPositon - scrollView.minHorizontalScrollPosition) * elasticityRatio;
			else if (newHorizontalScrollPositon > scrollView.maxHorizontalScrollPosition)
				newHorizontalScrollPositon -= (newHorizontalScrollPositon - scrollView.maxHorizontalScrollPosition) * elasticityRatio;
			scrollView.horizontalScrollPosition = newHorizontalScrollPositon;
		}
		
		private function throwHorizontalScrollPosition(newHorizontalScrollPositon:Number, duration:Number, ease:IEase):void
		{
			if (scrollView.horizontalScrollPosition < scrollView.minHorizontalScrollPosition ||
				scrollView.horizontalScrollPosition > scrollView.maxHorizontalScrollPosition)
				finishHorizontalScrollPosition();
			else
			{
				if (newHorizontalScrollPositon < scrollView.minHorizontalScrollPosition)
				{
					newHorizontalScrollPositon = scrollView.minHorizontalScrollPosition;
					duration = scrollView.minHorizontalScrollPosition / newHorizontalScrollPositon * duration;
				}
				else if (newHorizontalScrollPositon > scrollView.maxHorizontalScrollPosition)
				{
					newHorizontalScrollPositon = scrollView.maxHorizontalScrollPosition;
					duration = scrollView.maxHorizontalScrollPosition / newHorizontalScrollPositon * duration;
				}
				
				// init animation
				if (!horizontalScrollThrowTween)
				{
					horizontalScrollThrowTween = new Animation(scrollView);
					horizontalScrollThrowTween.addEventListener(AnimationEvent.COMPLETE, finishThrowHorizontalScrollPosition);
				}
				
				// stop and clear
				horizontalScrollThrowTween.stop();
				horizontalScrollThrowTween.clear();
				horizontalScrollThrowTween.duration = duration;
				horizontalScrollThrowTween.ease = ease;
				horizontalScrollThrowTween.add("horizontalScrollPosition", newHorizontalScrollPositon);
				horizontalScrollThrowTween.start();
			}
		}
		
		private function finishThrowHorizontalScrollPosition(event:AnimationEvent):void
		{
			finishHorizontalScrollPosition();
		}
		
		private function finishHorizontalScrollPosition():void
		{
			var finishHorizontalScrollPosition:Number = NaN;
			if (scrollView.horizontalScrollPosition < scrollView.minHorizontalScrollPosition)
				finishHorizontalScrollPosition = scrollView.minHorizontalScrollPosition;
			else if (scrollView.horizontalScrollPosition > scrollView.maxHorizontalScrollPosition)
				finishHorizontalScrollPosition = scrollView.maxHorizontalScrollPosition;
			
			if (!isNaN(finishHorizontalScrollPosition))
			{
				if (!horizontalScrollFinishTween)
					horizontalScrollFinishTween = new Animation(scrollView, elasticityDuration, elasticityEase);
				horizontalScrollFinishTween.stop();
				horizontalScrollFinishTween.clear();
				horizontalScrollFinishTween.add("horizontalScrollPosition", finishHorizontalScrollPosition);
				horizontalScrollFinishTween.start();
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		//  Vertical Drag Scroll 
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		private function dragVertical(verticalDistance:Number):void
		{
			var scale:Number = scrollView.application ? scrollView.application.scaleY : 1;
			verticalDistance = verticalDistance / scale; // application was scale
			dragVerticalScrollPosition(verticalScrollPositionOld - verticalDistance);
		}
		
		private function throwVertical(verticalVelocity:Number):void
		{
			var scale:Number = scrollView.application ? scrollView.application.scaleY : 1;
			verticalVelocity = verticalVelocity / scale; // application was scale
			verticalScrollPositionOld = scrollView.verticalScrollPosition;
			
			if (Math.abs(verticalVelocity) > minVelocity)
			{
				if (scrollView.pageScrollEnabled)
				{
					var newPage:int = verticalVelocity > 0 ? (mouseDownVerticalPage -1) : (mouseDownVerticalPage + 1);
					if (newPage > verticalMaxPage)
					{
						scrollView.dispatchEvent(new DragEvent(DragEvent.PAGE_END));
					}
					else if (newPage < 1)
					{
						scrollView.dispatchEvent(new DragEvent(DragEvent.PAGE_BEGIN));
					}
					else
					{
						//					debug("[ScrollHelper] Vertical Page: " + newPage);
						throwVerticalScrollPosition(newPage * scrollView.minVerticalScrollPosition, pageDuration, pageEase);
					}
				}
				else
				{
					// 垂直滚动
					throwVerticalScrollPosition(verticalScrollPositionOld + getThrowDistance(verticalVelocity), 
						getThrowDuration(verticalVelocity), throwEase);
				}
			}
			else
				finishVerticalScrollPosition();
		}
		
		private function dragVerticalScrollPosition(newVerticalScrollPosition:Number):void
		{
			if (newVerticalScrollPosition < scrollView.minVerticalScrollPosition)
				newVerticalScrollPosition -= (newVerticalScrollPosition - scrollView.minVerticalScrollPosition) * elasticityRatio;
			else if (newVerticalScrollPosition > scrollView.maxVerticalScrollPosition)
				newVerticalScrollPosition -= (newVerticalScrollPosition - scrollView.maxVerticalScrollPosition) * elasticityRatio;
			scrollView.verticalScrollPosition = newVerticalScrollPosition;
		}
		
		private function throwVerticalScrollPosition(newVerticalScrollPositon:Number, duration:Number, ease:IEase):void
		{
			if (scrollView.verticalScrollPosition < scrollView.minVerticalScrollPosition ||
				scrollView.verticalScrollPosition > scrollView.maxVerticalScrollPosition)
				finishVerticalScrollPosition();
			else
			{
				if (newVerticalScrollPositon < scrollView.minVerticalScrollPosition)
				{
					newVerticalScrollPositon = scrollView.minVerticalScrollPosition;
					duration = scrollView.minVerticalScrollPosition / newVerticalScrollPositon * duration;
				}
				else if (newVerticalScrollPositon > scrollView.maxVerticalScrollPosition)
				{
					newVerticalScrollPositon = scrollView.maxVerticalScrollPosition;
					duration = scrollView.maxVerticalScrollPosition / newVerticalScrollPositon * duration;
				}
				
				if (!verticalScrollThrowTween)
				{
					verticalScrollThrowTween = new Animation(scrollView);
					verticalScrollThrowTween.addEventListener(AnimationEvent.COMPLETE, finishThrowVerticalScrollPosition);
				}
				
				verticalScrollThrowTween.stop();
				verticalScrollThrowTween.clear();
				verticalScrollThrowTween.duration = duration;
				verticalScrollThrowTween.ease = ease;
				verticalScrollThrowTween.add("verticalScrollPosition", newVerticalScrollPositon);
				verticalScrollThrowTween.start();
			}
		}
		
		private function finishThrowVerticalScrollPosition(event:AnimationEvent):void
		{
			finishVerticalScrollPosition();
		}
		
		private function finishVerticalScrollPosition():void
		{
			var finishVerticalScrollPosition:Number = NaN;
			if (scrollView.verticalScrollPosition < scrollView.minVerticalScrollPosition)
			{
				finishVerticalScrollPosition = scrollView.minVerticalScrollPosition;
				
				// 下拉超过刷新范围 派发刷新事件
				if (scrollView.verticalScrollPosition < scrollView.minVerticalScrollPosition * dragRefreshRation)
					needDispatchDragRefreshEvent = true;
			}
			else if (scrollView.verticalScrollPosition > scrollView.maxVerticalScrollPosition)
				finishVerticalScrollPosition = scrollView.maxVerticalScrollPosition;
			
			if (!isNaN(finishVerticalScrollPosition))
			{
				if (!verticalScrollFinishTween)
					verticalScrollFinishTween = new Animation(scrollView, elasticityDuration, elasticityEase);
				verticalScrollFinishTween.stop();
				verticalScrollFinishTween.clear();
				verticalScrollFinishTween.add("verticalScrollPosition", finishVerticalScrollPosition);
				verticalScrollFinishTween.addEventListener(AnimationEvent.COMPLETE, verticalScrollFinishTween_completeHandler);
				verticalScrollFinishTween.start();
			}
		}
		
		protected function verticalScrollFinishTween_completeHandler(event:AnimationEvent):void
		{
			if (needDispatchDragRefreshEvent)
				scrollView.dispatchEvent(new DragEvent(DragEvent.DRAG_REFRESH));
		}
		
		public function finishScrollPosition():void
		{
			needDispatchDragRefreshEvent = false;
			
			if (horizontalScrollFinishTween)
				AnimationManager.remove(horizontalScrollFinishTween);
			if (horizontalScrollThrowTween)
				AnimationManager.remove(horizontalScrollThrowTween);
			if (verticalScrollFinishTween)
				AnimationManager.remove(verticalScrollFinishTween);
			if (verticalScrollThrowTween)
				AnimationManager.remove(verticalScrollThrowTween);
		}
		
		//		protected function calculateThrowDuration(velocity:Number):Number
		//		{
		//			return Math.log(MIN_VELOCITY / Math.abs(velocity)) / LOG_DECELERATION_RATE;
		//		}
		//		
		//		protected function calculateThrowDistance(velocity:Number):Number
		//		{
		//			return (velocity - MIN_VELOCITY) / LOG_DECELERATION_RATE;
		//		}
		
		/**
		 * 根据速度获取投掷的持续时间
		 */		
		private function getThrowDuration(velocity:Number):Number
		{
			if (velocity == 0) return 0;
			// 指定一个最小的速度 当速度小于最小速度的时候 即投掷结束
			// 最小速度设置为 minVelocity(pixel/ms)= 0.01 
			// 计算时间的公式  velocity(pixel/ms) * decelerationRate ^ time(ms) - minVelocity ＝ 0；
			// time = Math.log(minVelocity / Math.abs(velocity)) / Math.log(decelerationRate);
			var time:Number = Math.log(minVelocity / Math.abs(velocity)) / Math.log(decelerationRate);
			return time;
		}
		
		private function getThrowDistance(velocity:Number):Number
		{
			if (velocity == 0) return 0;
			// 指定一个最小速度 当速度小于最小速度的时候 即投掷结束
			// 最小速度设置为 minVelocity(pixel/ms) = 0.01 
			// 计算距离的公式为 distance = (velocity(pixel/ms) - minVelocity(pixel/ms)) / 2 * time(ms)
			var time:Number = getThrowDuration(velocity);
			var distance:Number = (Math.abs(velocity)- minVelocity) / 2 * time;
			return velocity < 0 ? distance : -distance;
		}
		
	}
}


class MousePoint
{
	public function MousePoint(x:Number, y:Number, time:int)
	{
		this.x = x;
		this.y = y;
		this.time = time;
	}
	
	public var x:Number;
	public var y:Number;
	public var time:int;
	
}
