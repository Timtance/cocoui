package coco.manager
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import coco.component.Label;
	import coco.core.Application;
	
	/**
	 *  工具提示管理器
	 * 	@author coco
	 */	
	public class ToolTipManager
	{
		public function ToolTipManager()
		{
		}
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//  Init
		//
		//----------------------------------------------------------------------------------------------------------------
		
		private static var _application:Application;
		
		public static function set application(value:Application):void
		{
			if (_application) throw Error("FocusManager must be singleton");
			
			_application = value;
			
			if (_application && _application.stage)
			{
				_application.stage.addEventListener(MouseEvent.MOUSE_OVER, stage_rollOverHandler);
				_application.stage.addEventListener(MouseEvent.MOUSE_OUT, stage_rollOutHandler);
			}
			else
			{
				_application.addEventListener(Event.ADDED_TO_STAGE, curApplication_addedToStageHandler);
			}
		}
		
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//  Variables
		//
		//----------------------------------------------------------------------------------------------------------------
		
		private static var _tipDisplay:Label;
		private static var delayTimeID:uint;
		
		
		//----------------------------------------------------------------------------------------------------------------
		//
		//  Methods
		//
		//----------------------------------------------------------------------------------------------------------------
		
		public static function get tipDisplay():Label
		{
			if (!_tipDisplay)
			{
				_tipDisplay = new Label();
				_tipDisplay.color = 0xFFFFFF;
				_tipDisplay.autoDrawSkin = true;
				_tipDisplay.backgroundAlpha = .7;
				_tipDisplay.borderAlpha = 0;
				_tipDisplay.backgroundColor = 0x000000;
				_tipDisplay.height = 22;
				_tipDisplay.leftMargin = _tipDisplay.rightMargin = 5;
			}
			
			return _tipDisplay;
		}
		
		protected static function stage_rollOutHandler(event:MouseEvent):void
		{
			clearTimeout(delayTimeID);
			
			if (_tipDisplay && _tipDisplay.isPopUp)
				PopUpManager.removePopUp(_tipDisplay);
		}
		
		protected static function stage_rollOverHandler(event:MouseEvent):void
		{
			clearTimeout(delayTimeID);
			
			var toolTipObject:IToolTip = event.target as IToolTip;
			if (toolTipObject)
				delayTimeID = setTimeout(showToolTip, 500, toolTipObject);
		}
		
		protected static function curApplication_addedToStageHandler(event:Event):void
		{
			_application.stage.addEventListener(MouseEvent.MOUSE_OVER, stage_rollOverHandler);
			_application.stage.addEventListener(MouseEvent.MOUSE_OUT, stage_rollOutHandler);
		}
		
		private static function showToolTip(toolTipObject:IToolTip):void
		{
			if (toolTipObject && 
				toolTipObject is DisplayObject && 
				toolTipObject.toolTip && 
				toolTipObject.toolTip.length > 0)
			{
				var gp:Point = DisplayObject(toolTipObject).localToGlobal(
					new Point(DisplayObject(toolTipObject).width / 2 + 10, DisplayObject(toolTipObject).height + 5));
				tipDisplay.text = toolTipObject.toolTip;
				tipDisplay.validateNow();
				if (!tipDisplay.isPopUp)
				{
					tipDisplay.x = gp.x;
					tipDisplay.y = gp.y;
					PopUpManager.addPopUp(tipDisplay, null);
				}
			}
		}
		
	}
}