package coco.component
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import coco.core.coco;
	import coco.event.UIEvent;
	import coco.manager.PopUpManager;
	import coco.util.CocoUI;
	
	use namespace coco;
	
	
	[Event(name="ui_close", type="coco.event.UIEvent")]
	
	/**
	 * 弹出 提示组件
	 * 
	 *   10     titleDisplay    10
	 *              10
	 *   10     textDisplay     10
	 *              10
	 *  cancelButton | okButton
	 * 
	 * @author Coco
	 */    
	public class Alert extends SkinComponent
	{
		public function Alert()
		{
			super();
		}
		
		public static const OK:uint = 0x0004;
		public static const CANCEL:uint= 0x0008;
		
		/**
		 * 显示
		 * 
		 * @param text 提示信息
		 * @param title 提示标题
		 * @param flags 提示操作按钮Alert.OK|Alert.CANCEL, Alert.OK, Alert.CANCEL
		 * @param closeHandler 提示窗口关闭响应事件
		 * @param parent 所属组件
		 * @param modal 是否是模态显示
		 * @param closeWhenMouseDownOutSide 点击外部区域是否自动关闭
		 * @param backgroundColor 模态背景颜色
		 * @param backgroundAlpha 模态背景透明度
		 * @return 
		 */     
		public static function show(text:String = "", 
									title:String = "",
									flags:uint = 0x4 /* Alert.OK */, 
									closeHandler:Function = null,
									parent:Sprite = null, 
									modal:Boolean = true,
									closeWhenMouseClickOutside:Boolean = false,
									backgroundColor:uint = 0x000000,
									backgroundAlpha:Number = .1):Alert
		{
			
			var alert:Alert = new Alert();
			alert.buttonFlags = flags;
			alert.text = text;
			alert.title = title;
			
			if (closeHandler != null)
				alert.addEventListener(UIEvent.CLOSE, closeHandler);
			
			PopUpManager.addPopUp(alert, parent, modal, closeWhenMouseClickOutside, backgroundColor, backgroundAlpha);
			PopUpManager.centerPopUp(alert);
			
			return alert;
		}
		
		private var _title:String;
		
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			if (_title == value) return;
			_title = value;
			invalidateProperties();
		}
		
		private var _text:String;
		
		public function get text():String
		{
			return _text;
		}
		
		public function set text(value:String):void
		{
			if (_text == value) return;
			_text = value;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		private var _cancelLabel:String = "取消";
		
		public function get cancelLabel():String
		{
			return _cancelLabel;
		}
		
		public function set cancelLabel(value:String):void
		{
			if (_cancelLabel == value) return;
			_cancelLabel = value;
			invalidateProperties();
		}
		
		private var _okLabel:String = "确定";
		
		public function get okLabel():String
		{
			return _okLabel;
		}
		
		public function set okLabel(value:String):void
		{
			if (_okLabel == value) return;
			_okLabel = value;
			invalidateProperties();
		}
		
		private var _headerHeight:Number = 30;
		
		public function get headerHeight():Number
		{
			return _headerHeight;
		}
		
		public function set headerHeight(value:Number):void
		{
			if (_headerHeight == value) return;
			_headerHeight = value;
			invalidateDisplayList();
		}
		
		
		private var _footHeight:Number = 30;
		
		public function get footHeight():Number
		{
			return _footHeight;
		}
		
		public function set footHeight(value:Number):void
		{
			if (_footHeight == value) return;
			_footHeight = value;
			invalidateDisplayList();
		}
		
		private var _textAlign:String = CocoUI.fontAlign;
		
		/**
		 * Alert 的文本对齐方式 
		 */
		public function get textAlign():String
		{
			return _textAlign;
		}
		
		/**
		 * @private
		 */
		public function set textAlign(value:String):void
		{
			if (_textAlign == value) return;
			_textAlign = value;
			invalidateProperties();
		}
		
		protected var titleDisplay:Label;
		protected var textDisplay:Label;
		protected var cancelButton:Button;
		protected var okButton:Button;
		public var buttonFlags:uint;
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			if (buttonFlags & Alert.CANCEL)
			{
				cancelButton = new Button();
				cancelButton.addEventListener(MouseEvent.CLICK, cancelButton_clickHandler);
				addChild(cancelButton);
			}
			
			if (buttonFlags & Alert.OK)
			{
				okButton = new Button();
				okButton.addEventListener(MouseEvent.CLICK, okButton_clickHandler);
				addChild(okButton);
			}
			
			if (title && title != "")
			{
				titleDisplay = new Label();
				titleDisplay.addEventListener(UIEvent.RESIZE, child_resizeHandler);
				addChild(titleDisplay);
			}
			
			textDisplay = new Label();
			textDisplay.leading = 5;
			textDisplay.x = 10;
			textDisplay.addEventListener(UIEvent.RESIZE, child_resizeHandler);
			addChild(textDisplay);
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (cancelButton)
				cancelButton.label = cancelLabel;
			
			if (okButton)
				okButton.label = okLabel;
			
			if (titleDisplay)
				titleDisplay.text = title;
			
			textDisplay.text = text;
			textDisplay.textAlign = textAlign;
		}
		
		override protected function measure():void
		{
			super.measure();
			
			//    10  titleDisplay 10
			//             10
			//    10  textDiplay   10
			//             10
			//  cancelButton  okButton
			
			// 如果titleDisplay存在  则有标题
			
			var minWidth:Number = 250;
			var minHeight:Number = 120;
			
			// header width
			var realWidth:Number = 0;
			var realHeight:Number = 0;
			if (titleDisplay)
			{
				realWidth = titleDisplay.width + 20;
				realHeight += headerHeight;
			}
			
			realWidth = Math.max(realWidth, textDisplay.width + 20);
			realHeight += textDisplay.height + 20;
			
			if (okButton || cancelButton)
			{
				realHeight += footHeight;
			}
			
			measuredWidth = Math.max(minWidth, realWidth);
			measuredHeight = Math.max(minHeight, realHeight);
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			textDisplay.x = 10;
			if (titleDisplay)
			{
				titleDisplay.x = 10;
				titleDisplay.setmeasuredSizeWithoutDispatchResizeEvent(width - 20, headerHeight);
				
				textDisplay.y = headerHeight + 10;
			}
			else
				textDisplay.y = 10;
			
			if (okButton || cancelButton)
				textDisplay.setmeasuredSizeWithoutDispatchResizeEvent(width - 20, height - footHeight - 10 - textDisplay.y);
			else
				textDisplay.setmeasuredSizeWithoutDispatchResizeEvent(width - 20, height - 10 - textDisplay.y);
			
			if (okButton && cancelButton)
			{
				okButton.width = cancelButton.width = okButton.x = width / 2;
				okButton.height = cancelButton.height = footHeight;
				okButton.y = cancelButton.y = height - footHeight;
			}
			else if (okButton)
			{
				okButton.width = width;
				okButton.height = footHeight;
				okButton.y = height - okButton.height;
			}
			else if (cancelButton)
			{
				cancelButton.width = width;
				cancelButton.height = footHeight;
				cancelButton.y = height - cancelButton.height;
			}
		}
		
		protected function child_resizeHandler(event:UIEvent):void
		{
			invalidateSize();
			invalidateDisplayList();
		}
		
		protected function cancelButton_clickHandler(event:MouseEvent):void
		{
			var ce:UIEvent = new UIEvent(UIEvent.CLOSE);
			ce.detail = Alert.CANCEL;
			dispatchEvent(ce);
			
			PopUpManager.removePopUp(this);
		}
		
		protected function okButton_clickHandler(event:MouseEvent):void
		{
			var ce:UIEvent = new UIEvent(UIEvent.CLOSE);
			ce.detail = Alert.OK;
			dispatchEvent(ce);
			
			PopUpManager.removePopUp(this);
		}
		
	}
}