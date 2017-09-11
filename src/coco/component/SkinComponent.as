package coco.component
{
	import coco.core.UIComponent;
	import coco.util.CocoUI;
	
	public class SkinComponent extends UIComponent
	{
		public function SkinComponent()
		{
			super();
		}
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Properties
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		//---------------------
		//	backgroundColor
		//---------------------
		
		private var _backgroundColor:uint = CocoUI.themeBackgroundColor;;

		/**
		 *
		 * 组件背景色
		 *  
		 * @return 
		 * 
		 */		
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}

		public function set backgroundColor(value:uint):void
		{
			if (_backgroundColor == value) return;
			_backgroundColor = value;
			invalidateSkin();
		}
		
		
		//---------------------
		//	backgroundAlpha
		//---------------------

		private var _backgroundAlpha:Number = CocoUI.themeBackgroundAlpha;

		/**
		 *
		 * 组件背景透明度
		 *  
		 * @return 
		 * 
		 */		
		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}

		public function set backgroundAlpha(value:Number):void
		{
			if (_backgroundAlpha == value) return;
			_backgroundAlpha = value;
			invalidateSkin();
		}
		
		
		//---------------------
		//	backgroundColor
		//---------------------

		private var _borderColor:uint = CocoUI.themeBorderColor;

		/**
		 * 边框颜色
		 */		
		public function get borderColor():uint
		{
			return _borderColor;
		}

		public function set borderColor(value:uint):void
		{
			if (_borderColor == value) return;
			_borderColor = value;
			invalidateSkin();
		}
		
		
		//---------------------
		//	borderAlpha
		//---------------------

		private var _borderAlpha:Number = CocoUI.themeBorderAlpha;

		/**
		 * 边框透明度
		 */		
		public function get borderAlpha():Number
		{
			return _borderAlpha;
		}

		public function set borderAlpha(value:Number):void
		{
			if (_borderAlpha == value) return;
			_borderAlpha = value;
			invalidateSkin();
		}
		
		//---------------------
		//	borderThickness
		//---------------------

		private var _borderThickness:Number = CocoUI.themeBorderThickness;

		/**
		 * 边框粗细
		 */		
		public function get borderThickness():Number
		{
			return _borderThickness;
		}

		public function set borderThickness(value:Number):void
		{
			if (_borderThickness == value) return;
			_borderThickness = value;
			invalidateSkin();
		}
		
		
		//---------------------
		//	topLeftRadius
		//---------------------

		private var _topLeftRadius:Number = CocoUI.themeRadius;

		/**
		 * 左上方半径
		 */		
		public function get topLeftRadius():Number
		{
			return _topLeftRadius;
		}

		public function set topLeftRadius(value:Number):void
		{
			if (_topLeftRadius == value) return;
			_topLeftRadius = value;
			invalidateSkin();
		}
		
		
		//---------------------
		//	topRightRadius
		//---------------------

		private var _topRightRadius:Number = CocoUI.themeRadius;

		/**
		 * 右上方半径
		 */		
		public function get topRightRadius():Number
		{
			return _topRightRadius;
		}

		public function set topRightRadius(value:Number):void
		{
			if (_topRightRadius == value) return;
			_topRightRadius = value;
			invalidateSkin();
		}
		
		
		//---------------------
		//	bottomLeftRadius
		//---------------------

		private var _bottomLeftRadius:Number = CocoUI.themeRadius;

		/**
		 * 左下方半径
		 */		
		public function get bottomLeftRadius():Number
		{
			return _bottomLeftRadius;
		}

		public function set bottomLeftRadius(value:Number):void
		{
			if (_bottomLeftRadius == value) return;
			_bottomLeftRadius = value;
			invalidateSkin();
		}
		
		
		//---------------------
		//	bottomRightRadius
		//---------------------

		private var _bottomRightRadius:Number = CocoUI.themeRadius;

		/**
		 * 右下方半径
		 */		
		public function get bottomRightRadius():Number
		{
			return _bottomRightRadius;
		}

		public function set bottomRightRadius(value:Number):void
		{
			if (_bottomRightRadius == value) return;
			_bottomRightRadius = value;
			invalidateSkin();
		}
		
		
		//---------------------
		//	radius
		//---------------------
		
		private var _radius:Number = CocoUI.themeRadius;

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			_radius = value;
			_topLeftRadius = _topRightRadius = _bottomLeftRadius = 
				_bottomRightRadius = _radius;
			invalidateSkin();
		}
		
		
		//---------------------
		//	autoDrawSkin
		//---------------------
		
		private var _autoDrawSkin:Boolean = true;

		/**
		 * 是否自动绘制皮肤
		 * 如果不自动绘制皮肤， 需要自己手动去绘制
		 */		
		public function get autoDrawSkin():Boolean
		{
			return _autoDrawSkin;
		}

		public function set autoDrawSkin(value:Boolean):void
		{
			if (_autoDrawSkin == value) return;
			_autoDrawSkin = value;
			invalidateSkin();
		}
		
		
		override protected function drawSkin():void
		{
			graphics.clear();
			
			if (autoDrawSkin)
			{
				graphics.lineStyle(borderThickness, borderColor, borderAlpha, true);
				graphics.beginFill(backgroundColor, backgroundAlpha);
				graphics.drawRoundRectComplex(0, 0, width, height, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius);
				graphics.endFill();
			}
		}

		
	}
}