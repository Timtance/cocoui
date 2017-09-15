package coco.util
{
	import flash.text.TextFormatAlign;
	
	import coco.core.coco;
	
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
		include "../core/Version.as";
		
		public function CocoUI()
		{
		}
		
		//---------------------------------------------------------------------------------------------------------------------
		//
		// Config
		//
		//---------------------------------------------------------------------------------------------------------------------
		
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
		public static var themeBackgroundColor:int = 0xFFFBF0;
		/**
		 * 主题背景选中色 
		 */		
		public static var themeBackgroundColorSelected:uint = 0xFFFFFF;
		/**
		 * 主题背景透明度
		 */		
		public static var themeBackgroundAlpha:Number = 1;
		/**
		 * 主题边框色 
		 */		
		public static var themeBorderColor:uint = 0xEEE6C9;
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
		
	}
}