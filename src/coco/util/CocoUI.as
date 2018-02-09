package coco.util
{
	import coco.core.coco;
	
	import flash.text.TextFormatAlign;
	
	use namespace coco;
	
	
	/**
	 *
	 * <p>
	 * LibConfig.enabled = true;
	 * LibConfig.level = Debug.LEVEL_ERROR;
	 * </p>
	 *  
	 * @author Coco
	 * 
	 */	
	public class CocoUI
	{
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Font
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 默认字体/全局字体  默认值为 null，这意味着 Flash Player 对文本使用 Times New Roman 字体
		 */        
		public static var fontFamily:String = null;
		/**
		 * 字体大小 默认 12 
		 */        
		public static var fontSize:int = 12;
		/**
		 * 字体缩放 默认 1 
		 */		
		public static var fontScale:Number = 1;
		
		/**
		 * 字体厚度 默认 细体
		 */        
		public static var fontBold:Boolean = false;
		/**
		 * 字体行间距 默认 0 
		 */        
		public static var fontLeading:Number = 0;
		/**
		 * 字体字符间距 默认 0 
		 */        
		public static var fontLetterSpacing:Number = 0;
		
		/**
		 * 文本对齐方式 
		 */        
		public static var fontAlign:String = TextFormatAlign.CENTER; 
		
		/**
		 * 表示块缩进，以像素为单位。 
		 */        
		public static var fontBlockIndent:Number = 0;
		
		/**
		 * 表示文本为带项目符号的列表的一部分。
		 */        
		public static var fontBullet:Boolean = false;
		
		/**
		 *  文本颜色
		 */		
		public static var fontColor:uint = 0x000000;
		
		/**
		 * 表示从左边距到段落中第一个字符的缩进。 
		 */        
		public static var fontIndent:Number = 0;
		
		/**
		 * 表示使用此文本格式的文本是否为斜体。 
		 */        
		public static var fontItalic:Boolean = false;
		
		/**
		 *  一个布尔值，表示是启用 (true) 还是禁用 (false) 字距调整。 
		 */        
		public static var fontKerning:Boolean = true;
		
		/**
		 * 段落的左边距，以像素为单位。 
		 */        
		public static var fontLeftMargin:Number = 0;
		
		/**
		 * 段落的右边距，以像素为单位。 
		 */        
		public static var fontRightMargin:Number = 0;
		
		/**
		 * 表示使用此文本格式的文本是带下划线 (true) 还是不带下划线 (false)。 
		 */        
		public static var fontUnderline:Boolean = false;
		
		/**
		 * 是否使用嵌入字体 默认false 
		 */		
		public static var embedFonts:Boolean = false;
		
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// THEME
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 主题背景色 
		 */		
		public static var themeBackgroundColor:int = 0xFFFFFF;
		/**
		 * 主题背景选中色 
		 */		
		public static var themeBackgroundColorSelected:uint = 0x498AE9;
		/**
		 * 主题背景透明度
		 */		
		public static var themeBackgroundAlpha:Number = 1;
		/**
		 * 主题边框色 
		 */		
		public static var themeBorderColor:uint = 0xDDDEE1;
		/**
		 * 主题边框透明度
		 */		
		public static var themeBorderAlpha:Number = 1;
		/**
		 * 主题边框圆角 
		 */		
		public static var themeRadius:Number = 2;
		/**
		 * 主题边框粗细 
		 */		
		public static var themeBorderThickness:Number = 1;
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// UTIL
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 使用图片缓存</br>
		 *  true 所有Image数据将被缓存，下次再调用相同路径的图片时，将从缓存中读取</br>
		 *  false不缓存Image数据</br>
		 */        
		public static var useImageCache:Boolean = true;
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Debug
		//
		//---------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 总的实例数目 
		 */        
		coco static var instanceCounter:int = 0;
		
		/**
		 * 是否使用CocoLib
		 * */
		coco static var useCocoLib:Boolean = true;
		
		/**
		 * 是否使用调试信息输出</br>
		 * true 所有使用debug方法的信息将会被输出
		 */		
		public static var useDebug:Boolean = false;
		
		/**
		 * 是否显示核心调试
		 * true 输出组件生命周期相关信息 
		 */		
		public static var useCore:Boolean = false;
		
		/**
		 * 是否使用性能监控 
		 */		
		public static var useMonitor:Boolean = false;
		
		coco static function montior(...args):void
		{
			if (useMonitor)
			{
				var arg:Array = args as Array;
				if (arg.length > 0)
					arg[0] = "[cocoui" + CocoUI.VERSION + "][Monitor]: " + arg[0];
				trace(arg);
			}
		}
		
		//--------------------------------------------------------------------------------------------------------------------------
		//
		//	Version BY COCO
		//
		//--------------------------------------------------------------------------------------------------------------------------
		/**
		 * Version 4.2.1
		 * 1 Use new cocolib.swz
		 */
		
		/**
		 * Version 4.2.0
		 * 1 Use cocolib.swz
		 */
		
		/**
		 * Version 4.1.1
		 * 1 Remove License Check
		 */
		
		/**
		 * Version 4.1.0
		 * 1 COCOLIB Support
		 */
		
		/**
		 * Version 4.0.9
		 * 1 COCOUI Lincese
		 */
		
		/**
		 * Version 4.0.8
		 * 1 Pull Request Test
		 */
		
		/**
		 * Version 4.0.7
		 * 1 支持主题功能 CocoUI.theme
		 * 2 List组件增加鼠标滚轮滚动支持
		 * 3 默认组件组件大小调整
		 */
		
		/**
		 * Version 4.0.6
		 * 1 移除 拖拽功能
		 * 2 DropDownList组件bug修复
		 * 3 URLLoader更名为URLLoaderWithTimeout
		 */
		
		/**
		 * Version 4.0.5
		 * 1 增加 支持拖拽功能
		 */
		
		/**
		 * Version 4.0.4
		 * 1 修复 RawView添加子组件失败bug
		 * 2 优化 PopUp弹框机制
		 */
		
		/**
		 * Version 4.0.3
		 * 1 增加fontScale属性，支持字体缩放
		 * 2 Image组件增加跨域检查
		 */
		
		/**
		 * Version 4.0.2
		 * 1 修改 NumericStepper 组件精度问题
		 */
		
		/**
		 * Version 4.0.1
		 * 1 修改 List Bug 修改
		 * 2 增加 List支持下拉更新事件DragEvent.DRAG_REFRESH
		 * 3 修改 TextInput 点击输入灵敏度
		 */
		
		/**
		 * Version 4.0.0
		 *
		 * 1 增加 全新的List组件 兼容PageList组件功能
		 * 2 删除 PageList组件 使用List组件替代
		 * 3 修改 全新的组件架构
		 * 4 修改 全新的布局机制
		 */
		coco static const VERSION:String = "4.2.1";
		
		/**
		 * Version 3.0.4</br>
		 * 1 优化 Label组件，支持更多属性</br>
		 * 2 修改 Label font - fontFamily</br>
		 * 3 修改 Button font - fontFamily</br>
		 * 4 增加 CocoConfig 字体设置</br>
		 * 5 增加 CocoConfig 主题设置</br>
		 * 6 修改 List 数据不刷新bug修改</br>
		 * 7 优化 PlatformUtil</br>
		 * 8 优化 Alert 支持textAlign</br>
		 * 9 修改 调试方法为debug</br>
		 * 10 修改 UIComponent setActualSize - setSizeWithoutDispatchUIEvent</br>
		 * 11 修改 PopUpUI自动关闭机制，mouseDown - mouseClick
		 * 12 优化 cocoui 渲染机制修改，提高性能
		 * 13 增加 UIComponent validateNow 方法
		 * 14 优化 Label 组件 添加操作方法
		 * 15 优化 框架性能 性能提升一倍
		 * 16 增加 焦点管理器FocusManager 支持焦点管理
		 * 17 增加 UIComponent 支持enabled属性
		 * 18 优化 Application 自适应问题
		 */
		
		/**
		 * Version 3.0.3</br>
		 *  1 UIComponent - Support 'isPopUp' property
		 */
		
		/**
		 * Version 3.0.2</br>
		 * 1 UIComponent - Support 'enabled' property
		 * 2 List - Support 'displayItemRendererFull' property
		 * 3 DefaultItemRenderer - label text clear when data is null
		 */
		
	}
}